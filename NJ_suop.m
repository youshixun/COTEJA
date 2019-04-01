function [En_NJ_out] =NJ_suop(Emn,En_NJ_in)
    En_NJ_out=(Emn+En_NJ_in-2*Emn*En_NJ_in)/(1-Emn*En_NJ_in);
end

