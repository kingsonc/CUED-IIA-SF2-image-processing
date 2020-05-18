function bits = dctbpp(Yr, N)

[m,n] = size(Yr);
sub_n = n/N;

bits = 0;

for i=1:sub_n:n
    for j=1:sub_n:m
        Ys = Yr(i:i+sub_n-1, j:j+sub_n-1);
        bits = bits + bpp(Ys) * length(Ys(:));
    end
end
