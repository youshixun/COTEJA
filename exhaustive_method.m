%威胁评估%
%地图考虑为15kmX15km%
%情景1：少对多
clc
clear 
Jammers_pos=[2 6 5;2 9 5;4 12 5;7 12 5];%干扰机布站
global M
M=size(Jammers_pos,1);
Radars_pos=[6 3 0;6 6 0;6 9 0;9 10 0;12 12 0];%雷达布站
global N
N=size(Radars_pos,1);
for m=1:M
    for n=1:N
        R(m,n)=norm(Jammers_pos(m,:)-Radars_pos(n,:));%距离参数
    end
end

Jamming_range=30;%干扰范围km
Radars_range=[12 10 12 14 15];%雷达范围km
Weapons_range=[3 4 3 4 5];%开火范围km
for n=1:N
P(:,n)=1-(R(:,n)-Weapons_range(n))/(Radars_range(n)-Weapons_range(n));
end

P(P<0)=0;P(P>1)=1;%遭遇概率%
Radar_stage=[0.25 0.5 0.75 1.0];%雷达阶段得分（搜索、捕获、跟踪、导引）
Radar_stage_Nt=[0 0 0 0 0];%转移时间
Radars_stage=[1 1 1 1 1];%雷达阶段设置

Radars_adv=[0.4 0.6 0.8 0.4 0.2];%雷达先进性设置
W=[3 2];%加权常数
Pn_1=ones(1,N);
Dn=zeros(1,N);
for n=1:N
    if Radars_stage(n)==4
        Radars_stage_next=4;
    else
        Radars_stage_next=Radars_stage(n)+1;
    end
    for m=1:M
    Pn_1(n)=(1-P(m,n))*Pn_1(n);
    end
    Dn(n)=(1-Pn_1(n))*(Radars_adv(n))*W*[Radar_stage(Radars_stage(n));(1-Radar_stage_Nt(n))*Radar_stage(Radars_stage_next)];%当前时间内的危险值
%     Dn(n)=(1-Pn_1(n))*W*[Radar_stage(Radars_stage(n));(1-Radar_stage_Nt(n))*Radar_stage(Radars_stage_next);Radars_adv(n)];%当前时间内的危险值
end

zuhe2=combntns([1 2 3 4 5],2);
lz2=length(zuhe2);
zuhe3=combntns([1 2 3 4 5],3);
lz3=length(zuhe3);
zuhe4=combntns([1 2 3 4 5],4);
lz4=length(zuhe4);
zuhe5=combntns([1 2 3 4 5],5);
lz5=length(zuhe5);

Se_factors=[ 0.8  0.9 1.0 -0.9 -0.9; 
             0.9  0.9 1.0 -0.9 -0.9;
            -0.9 -0.9 0.0 0.9   0.8;
            -0.9 -0.9 0.0 0.8   0.9];
        
R2=(1-R/Jamming_range).^2;
%Code%
Code=[1     1     1     1     0     0     0    0;
      1     1     1     1     0     0     0    0;
      1     1     1     1     0     0     0    0;
      1     1     1     1     0     0     0    0];
D_total_min=100;
for i1=1:5
    Code(1,1)=i1;
    if i1==1
        for j1=1:3
             Code(1,2)=j1;
             if j1==1
                Code(1,2:3)=[1,1];
                for k1=1:N
                    Code(1,4)=k1;
                end
             else
                 if j1==2
                     for jj1=1:3
                         Code(1,2:3)=[2,jj1];
                         if jj1==1
                            for k1=1:N
                               Code(1,4)=k1;
                            end
                         else
                             if jj1==2
                                 for jjj1=1:lz2
                                     Code(1,4:5)=zuhe2(jjj1,:);
                                 end
                             else
                                 for jjj1=1:lz3
                                     Code(1,4:6)=zuhe3(jjj1,:);
                                 end
                             end
                         end
                     end
                 else
                     for jj1=1:5
                         Code(1,2:3)=[2,jj1];
                         if jj1==1
                            for k1=1:N
                               Code(1,4)=k1;
                            end
                         else
                             if jj1==2
                                 for jjj1=1:lz2
                                     Code(1,4:5)=zuhe2(jjj1,:);
                                 end
                             else
                                 if jj1==3
                                     for jjj1=1:lz3
                                         Code(1,4:6)=zuhe3(jjj1,:);
                                     end
                                 else
                                     if jj1==4
                                         for jjj1=1:lz4
                                            Code(1,4:7)=zuhe4(jjj1,:);
                                         end
                                     else
                                         for jjj1=1:lz5
                                            Code(1,4:8)=zuhe5(jjj1,:);
                                         end
                                     end
                                 end
                             end
                         end   
                     end
                 end
             end
        end
    else
        Code(1,2:3)=[0,1];
        for k1=1:N
            Code(1,4)=k1;
        end
    end
 
    for i2=1:5
        Code(2,1)=i2;
        if i2==1
            for j2=1:3
                 Code(2,2)=j2;
                 if j2==1
                    Code(2,2:3)=[1,1];
                    for k2=1:N
                        Code(2,4)=k2;
                    end
                 else
                     if j2==2
                         for jj2=1:3
                             Code(2,2:3)=[2,jj2];
                             if jj2==1
                                for k2=1:N
                                   Code(2,4)=k2;
                                end
                             else
                                 if jj2==2
                                     for jjj2=1:lz2
                                         Code(2,4:5)=zuhe2(jjj2,:);
                                     end
                                 else
                                     for jjj2=1:lz3
                                         Code(2,4:6)=zuhe3(jjj2,:);
                                     end
                                 end
                             end
                         end
                     else
                         for jj2=1:5
                             Code(2,2:3)=[2,jj2];
                             if jj2==1
                                for k2=1:N
                                   Code(2,4)=k2;
                                end
                             else
                                 if jj2==2
                                     for jjj2=1:lz2
                                         Code(2,4:5)=zuhe2(jjj2,:);
                                     end
                                 else
                                     if jj2==3
                                         for jjj2=1:lz3
                                             Code(2,4:6)=zuhe3(jjj2,:);
                                         end
                                     else
                                         if jj2==4
                                             for jjj2=1:lz4
                                                Code(2,4:7)=zuhe4(jjj2,:);
                                             end
                                         else
                                             for jjj2=1:lz5
                                                Code(2,4:8)=zuhe5(jjj2,:);
                                             end
                                         end
                                     end
                                 end
                             end   
                         end
                     end
                 end
            end
        else
            Code(2,2:3)=[0,1];
            for k2=1:N
                Code(2,4)=k2;
            end
        end 
        for i3=1:5
            Code(3,1)=i3;
            if i3==1
                for j3=1:3
                     Code(3,2)=j3;
                     if j3==1
                        Code(3,2:3)=[1,1];
                        for k3=1:N
                            Code(3,4)=k3;
                        end
                     else
                         if j3==2
                             for jj3=1:3
                                 Code(3,2:3)=[2,jj3];
                                 if jj3==1
                                    for k3=1:N
                                       Code(3,4)=k3;
                                    end
                                 else
                                     if jj3==2
                                         for jjj3=1:lz2
                                             Code(3,4:5)=zuhe2(jjj3,:);
                                         end
                                     else
                                         for jjj3=1:lz3
                                             Code(3,4:6)=zuhe3(jjj3,:);
                                         end
                                     end
                                 end
                             end
                         else
                             for jj3=1:5
                                 Code(3,2:3)=[2,jj3];
                                 if jj3==1
                                    for k3=1:N
                                       Code(3,4)=k3;
                                    end
                                 else
                                     if jj3==2
                                         for jjj3=1:lz2
                                             Code(3,4:5)=zuhe2(jjj3,:);
                                         end
                                     else
                                         if jj3==3
                                             for jjj3=1:lz3
                                                 Code(3,4:6)=zuhe3(jjj3,:);
                                             end
                                         else
                                             if jj3==4
                                                 for jjj3=1:lz4
                                                    Code(3,4:7)=zuhe4(jjj3,:);
                                                 end
                                             else
                                                 for jjj3=1:lz5
                                                    Code(3,4:8)=zuhe5(jjj3,:);
                                                 end
                                             end
                                         end
                                     end
                                 end   
                             end
                         end
                     end
                end
            else
                Code(3,2:3)=[0,1];
                for k3=1:N
                    Code(3,4)=k3;
                end
            end 
            for i4=1:5
                Code(m4,1)=i4;
                if i4==1
                    for j4=1:3
                         Code(4,2)=j4;
                         if j4==1
                            Code(4,2:3)=[1,1];
                            for k4=1:N
                                Code(4,4)=k4;
                            end
                         else
                             if j4==2
                                 for jj4=1:3
                                     Code(4,2:3)=[2,jj4];
                                     if jj4==1
                                        for k4=1:N
                                           Code(4,4)=k4;
                                        end
                                     else
                                         if jj4==2
                                             for jjj4=1:lz2
                                                 Code(4,4:5)=zuhe2(jjj4,:);
                                             end
                                         else
                                             for jjj4=1:lz3
                                                 Code(4,4:6)=zuhe3(jjj4,:);
                                             end
                                         end
                                     end
                                 end
                             else
                                 for jj4=1:5
                                     Code(4,2:3)=[2,jj4];
                                     if jj4==1
                                        for k4=1:N
                                           Code(1,4)=k4;
                                        end
                                     else
                                         if jj4==2
                                             for jjj4=1:lz2
                                                 Code(4,4:5)=zuhe2(jjj4,:);
                                             end
                                         else
                                             if jj4==3
                                                 for jjj4=1:lz3
                                                     Code(4,4:6)=zuhe3(jjj4,:);
                                                 end
                                             else
                                                 if jj4==4
                                                     for jjj4=1:lz4
                                                        Code(4,4:7)=zuhe4(jjj4,:);
                                                     end
                                                 else
                                                     for jjj4=1:lz5
                                                        Code(4,4:8)=zuhe5(jjj4,:);
                                                     end
                                                 end
                                             end
                                         end
                                     end   
                                 end
                             end
                         end
                    end
                else
                    Code(4,2:3)=[0,1];
                    for k4=1:N
                        Code(4,4)=k4;
                    end
                end 
                for i5=1:5
                    Code(5,1)=i5;
                    if i5==1
                    for j5=1:3
                         Code(5,2)=j5;
                         if j5==1
                            Code(5,2:3)=[1,1];
                            for k5=1:N
                                Code(5,4)=k5;
                            end
                         else
                             if j5==2
                                 for jj5=1:3
                                     Code(5,2:3)=[2,jj5];
                                     if jj5==1
                                        for k2=1:N
                                           Code(5,4)=k5;
                                        end
                                     else
                                         if jj5==2
                                             for jjj5=1:lz2
                                                 Code(5,4:5)=zuhe2(jjj5,:);
                                             end
                                         else
                                             for jjj5=1:lz3
                                                 Code(5,4:6)=zuhe3(jjj5,:);
                                             end
                                         end
                                     end
                                 end
                             else
                                 for jj5=1:5
                                     Code(5,2:3)=[2,jj5];
                                     if jj5==1
                                        for k5=1:N
                                           Code(5,4)=k5;
                                        end
                                     else
                                         if jj5==2
                                             for jjj5=1:lz2
                                                 Code(5,4:5)=zuhe2(jjj5,:);
                                             end
                                         else
                                             if jj5==3
                                                 for jjj5=1:lz3
                                                     Code(5,4:6)=zuhe3(jjj5,:);
                                                 end
                                             else
                                                 if jj5==4
                                                     for jjj5=1:lz4
                                                        Code(5,4:7)=zuhe4(jjj5,:);
                                                     end
                                                 else
                                                     for jjj5=1:lz5
                                                        Code(5,4:8)=zuhe5(jjj5,:);
                                                     end
                                                 end
                                             end
                                         end
                                     end   
                                 end
                             end
                         end
                    end
                    else
                        Code(5,2:3)=[0,1];
                        for k5=1:N
                            Code(5,4)=k5;
                        end
                    end 
                end
            end
        end       
    end
end











for m=1:M
    [Emn(m,:),Tech(m,:)]=Decoding(m,Code(m,:),R2,Radars_stage,Se_factors);
end
[En_final]=En_Final(Emn,Tech); 
Dn_total_current=(1.-En_final).*Dn;
if sum(Dn_total_current)<D_total_min
    D_total_min=sum(Dn_total_current);
end
