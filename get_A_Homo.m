function [A,b] = get_A_Homo(x, X)

n = size(x, 2);

h = 1;
h_b=1;

for k =1:n
    
    A(h, :) = [X(1, k) X(2, k) 1 0 0 0 -x(1, k)*X(1, k) -x(1, k)*X(2, k)];
    A(h + 1, :) = [0 0 0 X(1, k) X(2, k) 1 -x(2, k)*X(1, k) -x(2, k)*X(2, k)];
    h = h + 2;
    b(h_b,:)=[x(1, k)];
    b(h_b+1,:)=[x(2, k)];
    h_b=h_b+2;
    
end;
return