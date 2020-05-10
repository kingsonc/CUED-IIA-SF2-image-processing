function [Y0, Y1, Y2, Y3, X4] = py4enc(X, h)

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

end
