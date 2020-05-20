%% LeGall filters
h1 = [-1 2 6 2 -1]/8; 
h2 = [-1 2 -1]/4;

%% filter rows
X_ = X - 128;
U = rowdec(X_,h1);
V = rowdec2(X,h2);

draw([U V]);set(gcf, 'Position',  [0, 0, 256, 256])

E_U = sum(U(:).^2);
disp(E_U);
E_V = sum(V(:).^2);
disp(E_V);

%% filter columns
UU = rowdec(U',h1)';
UV = rowdec2(U',h2)';
VU = rowdec(V',h1)';
VV = rowdec2(V',h2)';

draw([UU VU; UV VV*2]);

%% reconstruction
g1=[1 2 1]/2; 
g2=[-1 -2 6 -2 -1]/4;

Ur = rowint(UU',g1)' + rowint2(UV',g2)';
Vr = rowint(VU',g1)' + rowint2(VV',g2)';

max(abs(Ur - U),[],'all')
max(abs(Vr - V),[],'all')

Xr = rowint(Ur,g1) + rowint2(Vr,g2);

max(abs(Xr - X_),[],'all')

%% function
Y = dwt(X-128); figure(1); draw(Y); set(gcf, 'Position',  [0, 0, 256, 256])
Xr = idwt(Y); figure(2); draw(Xr); set(gcf, 'Position',  [0, 0, 256, 256])

%% multilevel DWT
m=256; Y=dwt(X);
m=m/2; t=1:m; Y(t,t)=dwt(Y(t,t));
m=m/2; t=1:m; Y(t,t)=dwt(Y(t,t));
m=m/2; t=1:m; Y(t,t)=dwt(Y(t,t));
% draw(Y);

Xr = Y;
Xr(t,t)=idwt(Xr(t,t));
m=m*2; t=1:m; Xr(t,t)=idwt(Xr(t,t));
m=m*2; t=1:m; Xr(t,t)=idwt(Xr(t,t));
m=m*2; t=1:m; Xr(t,t)=idwt(Xr(t,t));
draw(Xr);

max_abs_diff = max(abs(X - Xr),[],'all');
disp(max_abs_diff);

%% nlevdwt
Y = nlevdwt(X-128, 3);
draw(Y);

Z = nlevidwt(Y, 3);
% draw(Z);

max_abs_diff = max(abs(X - Z - 128),[],'all');
disp(max_abs_diff);

%% impulse measurement
Y = zeros(256,256);

% impulse
% layer 1
% Y(64,192) = 100;
% Y(192,64) = 100;
% Y(192,192) = 100;

% layer 2
% Y(32,96) = 100;
% Y(96,32) = 100;
% Y(96,96) = 100;

% layer 3
% Y(16,48) = 100;
% Y(48,16) = 100;
% Y(48,48) = 100;

% layer 4
% Y(8,24) = 100;
% Y(24,8) = 100;
% Y(24,24) = 100;

% layer 5
% Y(4,12) = 100;
% Y(12,4) = 100;
% Y(12,12) = 100;

% layer 6
% Y(2,6) = 100;
% Y(6,2) = 100;
% Y(6,6) = 100;

Z = nlevidwt(Y, 6);
sqrt(sum(Z(:).^2))

%% quantise
N = 4;
Y = nlevdwt(X-128, N);
[Yq, dwtent] = quantdwt(Y, N, 0.05);

Z = nlevidwt(Yq, N);
draw(Z);

rms_err = std(X(:) - Z(:));
disp(rms_err);

max_abs_diff = max(abs(X - Z - 128),[],'all');
disp(max_abs_diff);

%% optimal
N = 4;
Y = nlevdwt(X-128, N);

direct_quant_rms_err = 4.9340;
best_diff_rms_err = 100;
best_step_size_scaling = 0;
% for step_size_scaling = 0.01:0.01:2  % equal MSE
for step_size_scaling = 5:0.01:15  % equal MSE
    [Yq, ~, ~] = quantdwt(Y, N, step_size_scaling);
    Z = nlevidwt(Yq, N);

    rms_err = std(X(:) - Z(:));
    if abs(rms_err - direct_quant_rms_err) < best_diff_rms_err
        best_diff_rms_err = abs(rms_err - direct_quant_rms_err);
        best_step_size_scaling = step_size_scaling;
    end
end

disp(best_diff_rms_err);
disp(best_step_size_scaling);

%% draw optimal
[Yq, dwtent, bits] = quantdwt(Y, N, best_step_size_scaling);
Z = nlevidwt(Yq, N);
draw(Z);
disp(bits);
