function [change,Radars_stage_dt,Radars_stage_Nt_dt] =Stagechange(Dne,Dn,Radars_stage,Radar_stage_Nt)%重置函数    
    global N
    change=0;%有无重置
    Radars_stage_dt=Radars_stage;
    Radars_stage_Nt_dt=Radar_stage_Nt;
    for n=1:N
        if Radars_stage(n)==1&&Radar_stage_Nt(n)==1%为1且已经被重置时
        else
            if Dne(n)/Dn(n)<=0.6
                change=1;
                Radars_stage_dt(n)=1;
                Radars_stage_Nt_dt(n)=1;
            end 
        end        
    end
end