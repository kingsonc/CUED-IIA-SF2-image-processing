%% entropies
bpp(quantise(X, 17))
bpp(quantise(X1, 17))
bpp(quantise(Y0, 17))

%% bits required
length(X(:)) * bpp(quantise(X, 17))
length(X1(:)) * bpp(quantise(X1, 17)) + length(Y0(:)) * bpp(quantise(Y0, 17))

%% quantise laplcian pyramid
h = [1 2 1] * 0.25;
[Y0, Y1, Y2, Y3, X4] = py4enc(X,h);
Y0q = quantise(Y0, 17);
Y1q = quantise(Y1, 17);
Y2q = quantise(Y2, 17);
Y3q = quantise(Y3, 17);
X4q = quantise(X4, 17);

[Z0, Z1, Z2, Z3] = py4dec(Y0q, Y1q, Y2q, Y3q, X4q, h);
draw(Z0);

rms_err = std(X(:) - Z0(:));
disp(rms_err);

%% quantise original image
Xq = quantise(X, 17);
rms_err = std(X(:) - Xq(:));
disp(rms_err);
draw(Xq);

%% optimise step size

direct_quant_rms_err = 4.9340;
best_diff_rms_err = 100;
best_step_size = 0;
for step_size_scaling = 5:0.01:20
    [Y0, Y1, Y2, Y3, X4] = py4enc(X,h);
    Y0q = quantise(Y0, step_size_scaling);
    Y1q = quantise(Y1, step_size_scaling);
    Y2q = quantise(Y2, step_size_scaling);
    Y3q = quantise(Y3, step_size_scaling);
    X4q = quantise(X4, step_size_scaling);

    [Z0, Z1, Z2, Z3] = py4dec(Y0q, Y1q, Y2q, Y3q, X4q, h);

    rms_err = std(X(:) - Z0(:));
    if abs(rms_err - direct_quant_rms_err) < best_diff_rms_err
        best_diff_rms_err = abs(rms_err - direct_quant_rms_err);
        best_step_size = step_size_scaling;
    end
end

disp(best_diff_rms_err);
disp(best_step_size);


%% show constant step size decoded image
[Y0, Y1, Y2, Y3, X4] = py4enc(X,h);
Y0q = quantise(Y0, best_step_size);
Y1q = quantise(Y1, best_step_size);
Y2q = quantise(Y2, best_step_size);
Y3q = quantise(Y3, best_step_size);
X4q = quantise(X4, best_step_size);
[Z0, Z1, Z2, Z3] = py4dec(Y0q, Y1q, Y2q, Y3q, X4q, h);

draw(Z0);

%% impulse response measurement

% test pyramid
Y0 = zeros(256,256);
Y1 = zeros(128,128);
Y2 = zeros(64,64);
Y3 = zeros(32,32);
X4 = zeros(16,16);

% impulse
% Y0(128,128) = 106.88;
% Y1(64,64) = 71.25;
% Y2(32,32) = 38.86;
% Y3(16,16) = 19.88;
X4(8,8) = 10;

[Z0, Z1, Z2, Z3] = py4dec(Y0, Y1, Y2, Y3, X4, h);

sqrt(sum(Z0(:).^2))

%% optimal equal MSE scheme

direct_quant_rms_err = 4.9340;
best_diff_rms_err = 100;
best_step_size_scaling = 0;
for step_size_scaling = 1:0.01:20
    [Y0, Y1, Y2, Y3, X4] = py4enc(X,h);
    Y0q = quantise(Y0, 10.688 * step_size_scaling);
    Y1q = quantise(Y1, 7.125 * step_size_scaling);
    Y2q = quantise(Y2, 3.887 * step_size_scaling);
    Y3q = quantise(Y3, 1.988 * step_size_scaling);
    X4q = quantise(X4, 1 * step_size_scaling);

    [Z0, Z1, Z2, Z3] = py4dec(Y0q, Y1q, Y2q, Y3q, X4q, h);

    rms_err = std(X(:) - Z0(:));
    if abs(rms_err - direct_quant_rms_err) < best_diff_rms_err
        best_diff_rms_err = abs(rms_err - direct_quant_rms_err);
        best_step_size_scaling = step_size_scaling;
    end
end

disp(best_diff_rms_err);
disp(best_step_size_scaling);

%% show equal MSE scheme decoded image
[Y0, Y1, Y2, Y3, X4] = py4enc(X,h);
Y0q = quantise(Y0, 10.688 * best_step_size_scaling);
Y1q = quantise(Y1, 7.125 * best_step_size_scaling);
Y2q = quantise(Y2, 3.887 * best_step_size_scaling);
Y3q = quantise(Y3, 1.988 * best_step_size_scaling);
X4q = quantise(X4, 1 * best_step_size_scaling);
[Z0, Z1, Z2, Z3] = py4dec(Y0q, Y1q, Y2q, Y3q, X4q, h);

draw(Z0);