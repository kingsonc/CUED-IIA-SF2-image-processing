function [Z0, Z1, Z2, Z3] = py4dec(Y0, Y1, Y2, Y3, X4, h)

Z3 = Y3 + rowint(rowint(X4,2*h)',2*h)';
Z2 = Y2 + rowint(rowint(Z3,2*h)',2*h)';
Z1 = Y1 + rowint(rowint(Z2,2*h)',2*h)';
Z0 = Y0 + rowint(rowint(Z1,2*h)',2*h)';

end