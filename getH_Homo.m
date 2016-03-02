function h = getH_Homo(x, X)

[A,b] = get_A_Homo(x, X);
h=A\b;
h=[h' 1];
h = reshape(h, 3, 3)';
return