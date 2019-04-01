function [Code_backwardN] =Pb(Code)
    global N
    Pb_difference=zeros(1,N);
    Code_backwardN=zeros(1,N);
    for n=1:N
        Pb_difference(n)=(find(Code(:,:,3)==Code(:,n,2)))-n;
        Code_backwardN(n+Pb_difference(n))=Code(:,n,1);
    end
end

