function [Dnp] =Dsum(Dn,stage)
    global N
    Dnp=Dn;
    %1.½×¶Î½»»¥Òø×Ó%
    Ss_factors=[ 0.1  0.0 0.0 0.0  
                 0.2  0.1 0.0 0.0 
                 0.3  0.2 0.1 0.0 
                 0.4  0.3 0.2 0.1];
     for n1=1:N
         for n2=n1+1:N
            Dnp(n1)=Dnp(n1)*(1+Ss_factors(stage(n2),stage(n1)));
            Dnp(n2)=Dnp(n2)*(1+Ss_factors(stage(n1),stage(n2)));
         end
     end
end

