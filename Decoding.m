function [Emn,Tech] =Decoding(m,Code,R2,Radars_stage,Se_factors)
    global N
    L=1;
    NJ=[0 0 0 0 0;
        -0.1 -0.2 -0.35 0 0;
        -0.15 -0.25 -0.4 -0.6 -0.8];
    Tech=zeros(1,N);
    Emn=zeros(1,N);  
    if Code(2)>1
        for i=1:Code(3)
            A=Code(i+3);
            Emn(A)=L*R2(m,A)*Se_factors(Radars_stage(A),Code(1))*(1+NJ(Code(2),Code(3)));
            Tech(A)=Code(1);
        end
    else
        Emn(Code(4))=L*R2(m,Code(4))*Se_factors(Radars_stage(Code(4)),Code(1));
        Tech(Code(4))=Code(1);
    end
end

