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
Code=[2     0     1     1     0     0     0    0;
      2     0     1     1     0     0     0    0;
      2     0     1     1     0     0     0    0;
      2     0     1     1     0     0     0    0];
D_total_min=100;
m=1;
for i=2:5
    Code(m,1)=i;
    Code(m,2:3)=[0 1];
    for j=1:N
        Code(m,4)=j;      
    end
end
