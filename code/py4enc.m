function [Y0, Y1, Y2, Y3, Y4, Y5, Y6, X1, X2, X3, X4, X5, X6, X7] = py4enc(X, h)

X_ = X - 128;

X1 = rowdec(rowdec(X_,h)',h)';
X1_int = rowint(rowint(X1,2*h)',2*h)';
Y0 = X_ - X1_int;

X2 = rowdec(rowdec(X1,h)',h)';
X2_int = rowint(rowint(X2,2*h)',2*h)';
Y1 = X1 - X2_int;

X3 = rowdec(rowdec(X2,h)',h)';
X3_int = rowint(rowint(X3,2*h)',2*h)';
Y2 = X2 - X3_int;

X4 = rowdec(rowdec(X3,h)',h)';
X4_int = rowint(rowint(X4,2*h)',2*h)';
Y3 = X3 - X4_int;

X5 = rowdec(rowdec(X4,h)',h)';
X5_int = rowint(rowint(X5,2*h)',2*h)';
Y4 = X4 - X5_int;

X6 = rowdec(rowdec(X5,h)',h)';
X6_int = rowint(rowint(X6,2*h)',2*h)';
Y5 = X5 - X6_int;

X7 = rowdec(rowdec(X6,h)',h)';
X7_int = rowint(rowint(X7,2*h)',2*h)';
Y6 = X6 - X7_int;

end
