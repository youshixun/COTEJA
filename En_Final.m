function [En_final] =En_Final(Emn,Tech)    
    global M
    global N
    %组合干扰交互
    INT=[0.0 0.0 0.2 -0.3 -0.3; 
         0.0 0.0 0.1  0.2  0.2;
         0.2 0.1 0.0 -0.2 -0.2;
         -0.3 0.2 -0.2 0.0 0.2;
         -0.3 0.2 -0.2 0.2 0.0];
    En=zeros(1,N);
    In=ones(1,N);
    En_final=zeros(1,N);
    for n=1:N
        En_NJ=0;
        for m=1:M
            if Tech(m,n)==1
                En_NJ=NJ_suop(Emn(m,n),En_NJ);%算子叠加
            else
                if Tech(m,n)>1
                    En(n)=En(n)+Emn(m,n);
                end
            end
        end
        En(n)=En(n)+En_NJ;
        %2-计算交叉因子
        Site=find(Tech(:,n)~=0);%非0的位置
        number_INT=length(Site);%分配的干扰机个数
        if number_INT>1
            for sj=2:number_INT
                for si=1:sj-1
                    In(n)=In(n)*(1+INT(Tech(Site(si),n),Tech(Site(sj),n)));
                end
            end
        end
        En_final(n)=En(n)*In(n);
        if En_final(n)>1
            En_final(n)=1;%修复
        end
    end
end