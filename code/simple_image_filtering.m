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
Xf = conv2(h, h, X, 'same');

draw(Xf);set(gcf, 'Position',  [0, 0, 256, 256])
%% filter row then col
Y_rc = conv2se(h,h,X')';
draw(Y_rc);set(gcf, 'Position',  [0, 0, 256, 256])

%% filter col then row
Y_cr = conv2se(h,h,X);
draw(Y_cr);set(gcf, 'Position',  [0, 0, 256, 256])

%% max absolute pixel difference
max_abs_diff = max(abs(Y_rc - Y_cr),[],'all');
disp(max_abs_diff);

%% high pass filter
Z = conv2se(h,h,X);  % low pass image
Y = X - Z;  % image - low pass = high pass
draw(Y);set(gcf, 'Position',  [0, 0, 256, 256])

%% energy content
E = sum(Y(:).^2);
disp(E);