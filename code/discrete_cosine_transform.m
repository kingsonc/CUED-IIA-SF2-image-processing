%% DCT
N = 16;
C = dct_ii(N);
% plot(C8');

Y = colxfm(colxfm(X-128,C)',C)';
draw(regroup(Y,N)/N); set(gcf, 'Position',  [0, 0, 256, 256])

%% energies of sub-images
R = regroup(Y,N)/N;

f = 6;
R = R(32*(f-1)+1:32*f,32*(f-1)+1:32*f);
E = sum(R.^2, 'all');
disp(E);

%% inverse DCT
Z = colxfm(colxfm(Y',C')',C');
draw(Z);

max_abs_diff = max(abs(Z - X + 128),[],'all');
disp(max_abs_diff);

%% basis functions
bases = [zeros(1,8); C'; zeros(1,8)];
draw(512*bases(:)*bases(:)');

%% quantisation
Y = colxfm(colxfm(X-128,C)',C)';
Yq = quantise(Y, 17);
Yr = regroup(Yq,N);
draw(Yr/N);

bits = dctbpp(Yr, N);
disp(bits);

bits = bpp(Yr) * length(Yr(:));
disp(bits);

%% reconstruct quantised
Z = colxfm(colxfm(Yq',C')',C');
rms_err = std(X(:) - Z(:));
disp(rms_err);

Xq = quantise(X, 17);
rms_err = std(X(:) - Xq(:));
disp(rms_err);

%% optimise step size
Y = colxfm(colxfm(X-128,C)',C)';

direct_quant_rms_err = 4.9340;
best_diff_rms_err = 100;
best_step_size = 0;
for step_size = 15:0.01:30
    Yq = quantise(Y, step_size);
    Z = colxfm(colxfm(Yq',C')',C');
    rms_err = std(X(:) - Z(:));
    if abs(rms_err - direct_quant_rms_err) < best_diff_rms_err
        best_diff_rms_err = abs(rms_err - direct_quant_rms_err);
        best_step_size = step_size;
    end
end

disp(best_diff_rms_err);
disp(best_step_size);

%% compression ratio
Yq = quantise(Y, best_step_size);
Yr = regroup(Yq,N);
draw(Yr);

bits = dctbpp(Yr, N);
disp(bits);

%% draw
% DCT compressed
Z = colxfm(colxfm(Yq',C')',C');
figure(1);
draw(Z); set(gcf, 'Position',  [0, 0, 256, 256])

% % direct quant
% Xq = quantise(X, 17);
% figure(2);
% draw(Xq);
% 
% % original
% figure(3);
% draw(X);

