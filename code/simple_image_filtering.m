N = 15;
h = halfcos(N);

%% conv in for loop
[r,c] = size(X);
Xf = zeros(r, c+N-1);
for i = 1:r
    Xf(i,:) = conv(X(i,:), h);
end

draw(Xf);

%% conv2 with `same` argument
Xf = conv2(1, h, X, 'same');

draw(Xf);
%% filter row then col
Y_rc = conv2se(h,h,X')';
draw(Y_rc);

%% filter col then row
Y_cr = conv2se(h,h,X);
draw(Y_cr);

%% max absolute pixel difference
max_abs_diff = max(abs(Y_rc - Y_cr),[],'all');
disp(max_abs_diff);

%% high pass filter
Z = conv2se(h,h,X);  % low pass image
Y = X - Z;  % image - low pass = high pass
draw(Y);

%% energy content
E = sum(Z(:).^2);
disp(E);