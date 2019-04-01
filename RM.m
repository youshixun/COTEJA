function [SQ3] =RM(np,NP)
    SQ=randperm(NP);
    SQ3=SQ(1:3);
    i=find(SQ3==np);
    if i<4
        for j=i:3
            SQ3(i)= SQ(i+1);
        end
    end
end