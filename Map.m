function [P]=Map(r_namx,R_namx,R)
    if R>R_namx
    P=0;
    else
        if R>r_namx
            P=(R_namx-R)/(R_namx-r_namx);
        else
            P=1;
        end
    end  
end

