% function Z0 = py4dec(Y0, Y1, Y2, Y3, X4, h)
% 
% Z3 = Y3 + rowint(rowint(X4,2*h)',2*h)';
% Z2 = Y2 + rowint(rowint(Z3,2*h)',2*h)';
% Z1 = Y1 + rowint(rowint(Z2,2*h)',2*h)';
% Z0 = Y0 + rowint(rowint(Z1,2*h)',2*h)';
% 
% end

function Z0 = py4dec(Y0, Y1, X2, h)
% Z6 = Y6 + rowint(rowint(X7,2*h)',2*h)';
% Z5 = Y5 + rowint(rowint(X6,2*h)',2*h)';
% Z4 = Y4 + rowint(rowint(X5,2*h)',2*h)';
% Z3 = Y3 + rowint(rowint(X4,2*h)',2*h)';
% Z2 = Y2 + rowint(rowint(X3,2*h)',2*h)';
Z1 = Y1 + rowint(rowint(X2,2*h)',2*h)';
Z0 = Y0 + rowint(rowint(Z1,2*h)',2*h)';
end
