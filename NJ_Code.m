function [NJ_ID_Code] =NJ_Code()
    NJ_ID=randi([1,3],1);%随机出噪声干扰的技术子类
    Radars_number_Code=1;
    if NJ_ID==2 
        Radars_number_Code=randi([1,3],1);
    end
    if NJ_ID==3
        Radars_number_Code=randi([1,5],1);
    end
    NJ_ID_Code=[NJ_ID Radars_number_Code];
end

