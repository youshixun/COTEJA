function [B]=Tech_Decode(tech)
    if tech<4
        B=1;
    else
        B=tech-2;
    end
end

