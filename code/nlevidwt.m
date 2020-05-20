function Z = nlevidwt(Yq, n)

m = length(Yq) / (2^(n-1));
t = 1:m;

Z = Yq;
Z(t,t) = idwt(Z(t,t));

for i=1:(n-1)
    m = m*2; 
    t = 1:m; 
    Z(t,t) = idwt(Z(t,t));
end
