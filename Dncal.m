function [Dn]=Dncal(P,W,Radars_adv,Radar_stage_Nt,Radars_stage,Radar_stage)    
    global N
    global M
    Pn_1=ones(1,N);
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
    end
end