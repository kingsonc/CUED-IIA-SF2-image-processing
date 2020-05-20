function Y = nlevdwt(X, n)

m = length(X);

Y = dwt(X);

for i=1:(n-1)
    m = m/2; 
    t = 1:m; 
    Y(t,t) = dwt(Y(t,t));
end
