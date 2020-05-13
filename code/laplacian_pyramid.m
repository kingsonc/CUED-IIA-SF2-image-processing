%% 3-tap filter
h = [1 2 1] * 0.25;

%% quarter-size lowpass
X1 = rowdec(X,h);
X1 = rowdec(X1',h)';
X1 = X1 - 128;
draw(X1);

%% interpolate
X0 = rowint(X1,2*h);
X0 = rowint(X0',2*h)';
Y0 = X - X0;
draw(Y0);

%% encode
[Y0, Y1, Y2, Y3, Y4, Y5, X1, X2, X3, X4, X5, X6] = py4enc(X,h);
draw(beside(Y0,beside(Y1,beside(Y2,beside(Y3,X4)))));

%% decode
[Z0, Z1, Z2, Z3] = py4dec(Y0, Y1, Y2, Y3, X4, h);
% Z0 should be identical to X
max(abs((X(:) - 128) - Z0(:)))
draw(beside(Z0,beside(Z1,beside(Z2,Z3))));
