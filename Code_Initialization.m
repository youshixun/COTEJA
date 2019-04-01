function [Code,Emn,Tech] =Code_Initialization(R2,Radars_stage,Se_factors)
    global M
    global N
    Code=zeros(M,N+3);
    Tech=zeros(M,N);
    Emn=zeros(M,N);       
    %tech_ID_NJ_ID_A_Radars_number_Code
    for m=1:M
        tech_ID=randi([1,5],1);%随机出干扰技术型号
        A=randperm(N);
        NJ_ID_Code=[0,1];
        if tech_ID==1
            NJ_ID_Code=NJ_Code();
        end
        Code(m,:)=[tech_ID NJ_ID_Code A]; 
        [Emn(m,:),Tech(m,:)]=Decoding(m,Code(m,:),R2,Radars_stage,Se_factors);
    end
end

