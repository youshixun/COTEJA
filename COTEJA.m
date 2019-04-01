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
Radars_range=[15 10 12 14 13];%雷达范围km
Weapons_range=[3 4 3 4 5];%开火范围km
for n=1:N
    P(:,n)=1-(R(:,n)-Weapons_range(n))/(Radars_range(n)-Weapons_range(n));
end
% scatter3(Jammers_pos(:,1),Jammers_pos(:,2),Jammers_pos(:,3),'b','filled');hold on;
% scatter3(Radars_pos(:,1),Radars_pos(:,2),Radars_pos(:,3),'r^','filled');
% axis([0 15 0 15 0 7])
show=1;
platform_illumination=0;
P(P<0)=0;P(P>1)=1;%遭遇概率%
Radar_stage=[0.2 0.5 0.8 1.0];%雷达阶段得分（搜索、捕获、跟踪、导引）
Radar_stage_Nt=[0.5 0.5 0.5 0.5 0.5];%干扰时2/4         ---as same as noPL
Radars_stage=[1 1 1 1 1];%雷达阶段设置
%------------------------------------PL------------------------------------
% Radar_stage_Nt=[1 0.5 0.5 0.5 1];%转移时间2 s后         ---as same as noPL 
% Radars_stage=[2 1 1 1 2];%雷达阶段设置

% Radar_stage_Nt=[1 0.5 0.5 0.5 1];%转移时间2 s后         ---as same as noPL
% Radars_stage=[3 1 1 1 3];%雷达阶段设置

% Radar_stage_Nt=[0 0.5 0.5 0.5 0];%转移时间1后           ---PL
% Radars_stage=[4 1 1 1 4];%雷达阶段设置

% Radar_stage_Nt=[0.5 0.5 0.5 1 0];%转移时间1后           ---noPL
% Radars_stage=[1 1 1 2 4];%雷达阶段设置

% Radar_stage_Nt=[0.5 1 0.5 1 0.5];%转移时间1后           ---PL
% Radars_stage=[1 2 1 2 1];%雷达阶段设置

% Radar_stage_Nt=[1 0.5 0.5 0.5 0.5];%转移时间1后           ---noPL
% Radars_stage=[2 1 1 1 1];%雷达阶段设置

% Radar_stage_Nt=[0.5 0.5 0.5 0.5 1];%转移时间1后         ---PL
% Radars_stage=[1 1 1 1 2];%雷达阶段设置

% Radar_stage_Nt=[1 0.5 0.5 0.5 1];%转移时间1后             ---noPL
% Radars_stage=[3 1 1 1 2];%雷达阶段设置

% Radar_stage_Nt=[1 0.5 0.5 0.5 1];%转移时间1后           ---PL
% Radars_stage=[2 1 1 1 3];%雷达阶段设置

% Radar_stage_Nt=[0.5 0.5 0.5 1 1];%转移时间1后           ---noPL
% Radars_stage=[1 1 1 2 3];%雷达阶段设置

Radars_adv=[0.4 0.6 0.8 0.4 0.2];%雷达先进性设置
W=[3 2];%加权常数

% 计算初始Dn  
Dn=zeros(1,N);
Dn=Dncal(P,W,Radars_adv,Radar_stage_Nt,Radars_stage,Radar_stage);
Dnp=Dsum(Dn,Radars_stage);%交互后

%威胁地图%
% Rd=0.1;
% x=0:Rd:15;
% y=0:Rd:15;
% z=0:Rd:15;
% I=numel(x);
% J=numel(y);%假设分辨率为100m
% K=numel(z);%假设分辨率为100m

%干扰效果评估%
%1.阶段有效性，即4阶段对应5技术%
if platform_illumination == 1
    Se_factors=[ 0.8  0.9 1.0 -0.9 -0.9; 
                 0.9  0.9 1.0 -0.9 -0.9;
                -0.9 -0.9 0.0 0.9   0.8;
                -0.9 -0.9 0.0 0.8   0.9];
else
    Se_factors=[ 0.8  0.9 1.0 0.2  0.2; 
                 0.9  0.9 1.0 0.1  0.1;
                 0.5  0.5 0.0 0.9  0.8;
                 0.5  0.5 0.0 0.8  0.9];
end
        
R2=(1-R/Jamming_range).^2;
%优化算法%
MEC=100;
NP=20;
G=500;%最大演化代数
tic
for mec=1:MEC
%初始化
Dnp_Initialization=zeros(NP,N);
Dn_Test=zeros(NP,N);
En_final_Test=zeros(NP,N);
Code_son=zeros(M,N+3,NP);
Dn_father=zeros(NP,N);
Dn_son=zeros(NP,N);
D_total_Mean=zeros(1,G);
D_total_Best=zeros(1,G);

%修改过的离散差分进化算法%

for np=1:NP
    %1-全随机父本
    [Code_Initial(:,:,np),Emn_I,Tech_I]=Code_Initialization(R2,Radars_stage,Se_factors);
    %计算En_final%
    En_final_Initialization=En_Final(Emn_I,Tech_I); 
    %收益(初始)
    Dnp_Initialization(np,:)=(1.-En_final_Initialization).*Dnp;%干扰后
    Radars_stage_0=Radars_stage;%干扰初
    Radar_stage_Nt_0=Radar_stage_Nt;
    Dn1=Dn;
    while 1
        %评估雷达状态是否被重置
        [change,Radars_stage_1(np,:),Radar_stage_Nt_1(np,:)]=Stagechange(Dnp_Initialization(np,:),Dn1,Radars_stage_0,Radar_stage_Nt_0);%change=1表示被重置
        if change==0
            break;%未重置
        end
        %3-收益计算%
        for m=1:M
            [Emn_I(m,:),Tech_I(m,:)]=Decoding(m,Code_Initial(m,:,np),R2,Radars_stage_1(np,:),Se_factors);
        end
        En_final_Initialization=En_Final(Emn_I,Tech_I); 
        Dn1=Dncal(P,W,Radars_adv,Radar_stage_Nt_1(np,:),Radars_stage_1(np,:),Radar_stage);
        Dnp1=Dsum(Dn1,Radars_stage_1(np,:));%交互后
        Dnp_Initialization(np,:)=(1.-En_final_Initialization).*Dnp1;%干扰后
        Radar_stage_Nt_0=Radar_stage_Nt_1(np,:);
        Radars_stage_0=Radars_stage_1(np,:);
    end   
end

for g=1:G
    Code_mutant=zeros(M,N+3,NP);
    Code_cross=zeros(M,N+3,NP);
    if g==1
        Code_father=Code_Initial;  
        Dn_father=Dnp_Initialization;
    else
        Code_father=Code_son;
        Dn_father=Dn_son;
    end
    for np=1:NP
        SQ=RM(np,NP);
        Code_mutant(:,:,np)=mutant(Code_father(:,:,SQ));
        for m=1:M
            if rand<=0.9
                Code_cross(m,:,np)=Code_mutant(m,:,np);
            else
                Code_cross(m,:,np)=Code_father(m,:,np);
            end
        end
        %3-收益计算%
        for m=1:M
            [Emn(m,:,np),Tech(m,:,np)]=Decoding(m,Code_cross(m,:,np),R2,Radars_stage,Se_factors);
        end
        %计算En_final%
        [En_final_Test(np,:)]=En_Final(Emn(:,:,np),Tech(:,:,np)); 
        %收益
        Dn_Test(np,:)=(1.-En_final_Test(np,:)).*Dnp;
        Radars_stage_0=Radars_stage;%干扰初
        Radar_stage_Nt_0=Radar_stage_Nt;
        Dn1=Dn;
        while 1
            %评估雷达状态是否被重置
            [change,Radars_stage_1(np,:),Radar_stage_Nt_1(np,:)]=Stagechange(Dn_Test(np,:),Dn1,Radars_stage_0,Radar_stage_Nt_0);%change=1表示被重置
            if change==0
                break;%未重置
            end
            %3-收益计算%
            for m=1:M
                [Emn(m,:,np),Tech(m,:,np)]=Decoding(m,Code_cross(m,:,np),R2,Radars_stage_1(np,:),Se_factors);
            end
            En_final_Test=En_Final(Emn(:,:,np),Tech(:,:,np)); 
            Dn1=Dncal(P,W,Radars_adv,Radar_stage_Nt_1(np,:),Radars_stage_1(np,:),Radar_stage);
            Dnp1=Dsum(Dn1,Radars_stage_1(np,:));%交互后
            Dn_Test(np,:)=(1.-En_final_Test).*Dnp1;%干扰后
            Radar_stage_Nt_0=Radar_stage_Nt_1(np,:);
            Radars_stage_0=Radars_stage_1(np,:);
        end  
        if sum(Dn_Test(np,:))<sum(Dn_father(np,:))%小的部分被替换
            Code_son(:,:,np)=Code_cross(:,:,np);
            Dn_son(np,:)=Dn_Test(np,:);
        else
            Code_son(:,:,np)=Code_father(:,:,np);
            Dn_son(np,:)=Dn_father(np,:);
        end
    end
    D_total_Mean(g)=mean(sum(Dn_son'));%平均值
    [D_total_Best(g),pos]=min(sum(Dn_son'));%最优解
    if  D_total_Mean(g)-D_total_Best(g)<1e-5
        break;
    end
end
    D_total_Mean_Best(mec)=D_total_Best(g);
    if mec==1
        Maxe=D_total_Mean_Best(mec);
        Code_Best=Code_son(:,:,pos);
        Dn_Best=Dn_son(pos,:);
        Radar_stage_Nt_Best=Radar_stage_Nt_1(pos,:);
        Radar_stage_Best=Radars_stage_1(pos,:);
    else
        if D_total_Mean_Best(mec)<Maxe
            Code_Best=Code_son(:,:,pos);
            Dn_Best=Dn_son(pos,:);
            Radar_stage_Nt_Best=Radar_stage_Nt_1(pos,:);
            Radar_stage_Best=Radars_stage_1(pos,:);
        end
    end
end
toc

[change,Radars_stage_next,Radar_stage_Nt_next]=Stagechange(Dn_Best,Dnp,Radars_stage,Radar_stage_Nt)

MEAN=mean(D_total_Mean_Best)
MIN=min(D_total_Mean_Best)
% sum(Dnp)
sum(Dn_Best)
(sum(Dnp)-MEAN)/(sum(Dnp)-MIN)

Code_Best

if show == 1
    figure
    hold on;
    plot(1:g,D_total_Mean(1:g),'r--','LineWidth',2);
    plot(1:g,D_total_Best(1:g),'b','LineWidth',2);
    xlabel('Number of iteration')
    ylabel('Total danger value')
    legend('ePDE: Mean value','ePDE: Best value')
    axis([1 500 0.5 4.5])
    grid on
end






