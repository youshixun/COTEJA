function [Code_mutant] =mutant(Code)
    global M
    global N
    Code_forward3=zeros(M,3);
    Code_backwardN=zeros(M,N);
    N_J=5;%干扰技术的最大ID
    for i=1:M
        Code_forward3(i,:)=Code(i,1:3,1)+Code(i,1:3,2)-Code(i,1:3,3);
        if Code_forward3(i,1)>N_J
            Code_forward3(i,1)=Code_forward3(i,1)-N_J;
        else
            if Code_forward3(i,1)<1
                Code_forward3(i,1)=Code_forward3(i,1)+N_J;
            end
        end
        if Code_forward3(i,1)>1
            Code_forward3(i,2:3)=[0 1];
        else
            Code_forward3(i,2:3)=NJ_Code();
        end
        Code_backwardN(i,:)=Pb(Code(i,4:N+3,:));%序列元素置换
    end
    Code_mutant=[Code_forward3 Code_backwardN];
end

