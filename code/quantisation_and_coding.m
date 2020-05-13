% h = [1 2 1] / 4;
h = [1 4 6 4 1] / 16;

%% entropies
bpp(quantise(X, 17))
bpp(quantise(X1, 17))
bpp(quantise(Y0, 17))

%% bits required 1 layer
length(X(:)) * bpp(quantise(X, 17))
length(X1(:)) * bpp(quantise(X1, 17)) + length(Y0(:)) * bpp(quantise(Y0, 17))

%% 2 layers
length(X2(:)) * bpp(quantise(X2, 17)) + length(Y0(:)) * bpp(quantise(Y0, 17)) + length(Y1(:)) * bpp(quantise(Y1, 17))

%% 3 layers
length(X3(:)) * bpp(quantise(X3, 17)) + length(Y0(:)) * bpp(quantise(Y0, 17)) + length(Y1(:)) * bpp(quantise(Y1, 17)) + length(Y2(:)) * bpp(quantise(Y2, 17))

%% 4 layers
length(X4(:)) * bpp(quantise(X4, 17)) + length(Y0(:)) * bpp(quantise(Y0, 17)) + length(Y1(:)) * bpp(quantise(Y1, 17)) + length(Y2(:)) * bpp(quantise(Y2, 17)) + length(Y3(:)) * bpp(quantise(Y3, 17))

%% 5 layers
length(X5(:)) * bpp(quantise(X5, 17)) + length(Y0(:)) * bpp(quantise(Y0, 17)) + length(Y1(:)) * bpp(quantise(Y1, 17)) + length(Y2(:)) * bpp(quantise(Y2, 17)) + length(Y3(:)) * bpp(quantise(Y3, 17)) + length(Y4(:)) * bpp(quantise(Y4, 17))

%% 6 layers
length(X6(:)) * bpp(quantise(X6, 17)) + length(Y0(:)) * bpp(quantise(Y0, 17)) + length(Y1(:)) * bpp(quantise(Y1, 17)) + length(Y2(:)) * bpp(quantise(Y2, 17)) + length(Y3(:)) * bpp(quantise(Y3, 17)) + length(Y4(:)) * bpp(quantise(Y4, 17)) + length(Y5(:)) * bpp(quantise(Y5, 17))

%% quantise laplcian pyramid
[Y0, Y1, Y2, Y3, Y4, Y5, Y6, X1, X2, X3, X4, X5, X6, X7] = py4enc(X,h);
Y0q = quantise(Y0, 17);
Y1q = quantise(Y1, 17);
Y2q = quantise(Y2, 17);
Y3q = quantise(Y3, 17);
Y4q = quantise(Y4, 17);
Y5q = quantise(Y5, 17);
Y6q = quantise(Y6, 17);
X1q = quantise(X1, 17);
X2q = quantise(X2, 17);
X3q = quantise(X3, 17);
X4q = quantise(X4, 17);
X5q = quantise(X5, 17);
X6q = quantise(X6, 17);
X7q = quantise(X7, 17);

Z0 = py4dec(Y0q, Y1q, Y2q, Y3q, Y4q, Y5q, Y6q, X7q, h);
draw(Z0);set(gcf, 'Position',  [0, 0, 256, 256])

rms_err = std(X(:) - Z0(:));
disp(rms_err);

%% quantise original image
Xq = quantise(X, 17);
rms_err = std(X(:) - Xq(:));
disp(rms_err);
draw(Xq);set(gcf, 'Position',  [0, 0, 256, 256])

%% optimise constant step size

direct_quant_rms_err = 4.9340;
best_diff_rms_err = 100;
best_step_size = 0;
for step_size_scaling = 5:0.01:20
    [Y0, Y1, Y2, Y3, Y4, Y5, Y6, X1, X2, X3, X4, X5, X6, X7] = py4enc(X,h);
    Y0q = quantise(Y0, step_size_scaling);
    Y1q = quantise(Y1, step_size_scaling);
    Y2q = quantise(Y2, step_size_scaling);
    Y3q = quantise(Y3, step_size_scaling);
    Y4q = quantise(Y4, step_size_scaling);
    Y5q = quantise(Y5, step_size_scaling);
    Y6q = quantise(Y6, step_size_scaling);
    X1q = quantise(X1, step_size_scaling);
    X2q = quantise(X2, step_size_scaling);
    X3q = quantise(X3, step_size_scaling);
    X4q = quantise(X4, step_size_scaling);
    X5q = quantise(X5, step_size_scaling);
    X6q = quantise(X6, step_size_scaling);
    X7q = quantise(X7, step_size_scaling);

    Z0 = py4dec(Y0q, Y1q, X2q, h);

    rms_err = std(X(:) - Z0(:));
    if abs(rms_err - direct_quant_rms_err) < best_diff_rms_err
        best_diff_rms_err = abs(rms_err - direct_quant_rms_err);
        best_step_size = step_size_scaling;
    end
end

disp(best_diff_rms_err);
disp(best_step_size);

%% show constant step size decoded image
[Y0, Y1, Y2, Y3, Y4, Y5, Y6, X1, X2, X3, X4, X5, X6, X7] = py4enc(X,h);
Y0q = quantise(Y0, best_step_size);
Y1q = quantise(Y1, best_step_size);
Y2q = quantise(Y2, best_step_size);
Y3q = quantise(Y3, best_step_size);
Y4q = quantise(Y4, best_step_size);
Y5q = quantise(Y5, best_step_size);
Y6q = quantise(Y6, best_step_size);
X1q = quantise(X1, best_step_size);
X2q = quantise(X2, best_step_size);
X3q = quantise(X3, best_step_size);
X4q = quantise(X4, best_step_size);
X5q = quantise(X5, best_step_size);
X6q = quantise(X6, best_step_size);
X7q = quantise(X7, best_step_size);
Z0 = py4dec(Y0q, Y1q, X2q, h);

bits = length(X7q(:)) * bpp(X7q);
bits = bits + length(Y0q(:)) * bpp(Y0q);
bits = bits + length(Y1q(:)) * bpp(Y1q);
bits = bits + length(Y2q(:)) * bpp(Y2q);
bits = bits + length(Y3q(:)) * bpp(Y3q);
bits = bits + length(Y4q(:)) * bpp(Y4q);
bits = bits + length(Y5q(:)) * bpp(Y5q);
bits = bits + length(Y6q(:)) * bpp(Y6q);

disp(bits);
draw(Z0);set(gcf, 'Position',  [0, 0, 256, 256])

%% impulse response measurement

% test pyramid
L0 = zeros(256,256);
L1 = zeros(128,128);
L2 = zeros(64,64);
L3 = zeros(32,32);
L4 = zeros(16,16);
L5 = zeros(8,8);
L6 = zeros(4,4);
L7 = zeros(2,2);

% impulse
% L0(128,128) = 100;
% L1(64,64) = 100;
% L2(32,32) = 100;
% L3(16,16) = 100;
% L4(8,8) = 100;
% L5(4,4) = 100;
% L6(2,2) = 100;
L7(1,1) = 100;

Z0 = py4dec(L0, L1, L2, L3, L4, L5, L6, L7, h);

sqrt(sum(Z0(:).^2))

%% optimal equal MSE scheme

direct_quant_rms_err = 4.9340;
best_diff_rms_err = 100;
best_step_size_scaling = 0;
for step_size_scaling = 0.01:0.01:2
    [Y0, Y1, Y2, Y3, Y4, Y5, Y6, X1, X2, X3, X4, X5, X6, X7] = py4enc(X,h);
    Y0q = quantise(Y0, 43.168 * step_size_scaling);
    Y1q = quantise(Y1, 28.77866667 * step_size_scaling);
    Y2q = quantise(Y2, 15.69745455 * step_size_scaling);
    Y3q = quantise(Y3, 8.031255814 * step_size_scaling);
    Y4q = quantise(Y4, 4.038922156 * step_size_scaling);
    Y5q = quantise(Y5, 2.022488756 * step_size_scaling);
    Y6q = quantise(Y6, 1.011623547 * step_size_scaling);
    X1q = quantise(X1, 28.77866667 * step_size_scaling);
    X2q = quantise(X2, 15.69745455 * step_size_scaling);
    X3q = quantise(X3, 8.031255814 * step_size_scaling);
    X4q = quantise(X4, 4.038922156 * step_size_scaling);
    X5q = quantise(X5, 2.022488756 * step_size_scaling);
    X6q = quantise(X6, 1.011623547 * step_size_scaling);
    X7q = quantise(X7, 1 * step_size_scaling);

    Z0 = py4dec(Y0q, Y1q, X2q, h);

    rms_err = std(X(:) - Z0(:));
    if abs(rms_err - direct_quant_rms_err) < best_diff_rms_err
        best_diff_rms_err = abs(rms_err - direct_quant_rms_err);
        best_step_size_scaling = step_size_scaling;
    end
end

disp(best_diff_rms_err);
disp(best_step_size_scaling);

%% show equal MSE scheme decoded image
[Y0, Y1, Y2, Y3, Y4, Y5, Y6, X1, X2, X3, X4, X5, X6, X7] = py4enc(X,h);
Y0q = quantise(Y0, 43.168 * best_step_size_scaling);
Y1q = quantise(Y1, 28.77866667 * best_step_size_scaling);
Y2q = quantise(Y2, 15.69745455 * best_step_size_scaling);
Y3q = quantise(Y3, 8.031255814 * best_step_size_scaling);
Y4q = quantise(Y4, 4.038922156 * best_step_size_scaling);
Y5q = quantise(Y5, 2.022488756 * best_step_size_scaling);
Y6q = quantise(Y6, 1.011623547 * best_step_size_scaling);
X1q = quantise(X1, 28.77866667 * best_step_size_scaling);
X2q = quantise(X2, 15.69745455 * best_step_size_scaling);
X3q = quantise(X3, 8.031255814 * best_step_size_scaling);
X4q = quantise(X4, 4.038922156 * best_step_size_scaling);
X5q = quantise(X5, 2.022488756 * best_step_size_scaling);
X6q = quantise(X6, 1.011623547 * best_step_size_scaling);
X7q = quantise(X7, 1 * best_step_size_scaling);
Z0 = py4dec(Y0q, Y1q, X2q, h);

bits = length(X1q(:)) * bpp(X1q);
bits = bits + length(Y0q(:)) * bpp(Y0q);
% bits = bits + length(Y1q(:)) * bpp(Y1q);
% bits = bits + length(Y2q(:)) * bpp(Y2q);
% bits = bits + length(Y3q(:)) * bpp(Y3q);
% bits = bits + length(Y4q(:)) * bpp(Y4q);
% bits = bits + length(Y5q(:)) * bpp(Y5q);
% bits = bits + length(Y6q(:)) * bpp(Y6q);

disp(bits);
draw(Z0);set(gcf, 'Position',  [0, 0, 256, 256])
