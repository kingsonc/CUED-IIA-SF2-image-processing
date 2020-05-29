function q = quant1_freq_dep(x, step, rise1, M)

% QUANT1 Quantise a matrix
%  Q = QUANT1(X, step, rise1) quantises the matrix X using steps
%  of width step.
%
%  The result is the quantised integers Q. If rise1 is defined,
%  the first step rises at rise1, otherwise it rises at step/2 to
%  give a uniform quantiser with a step centred on zero.
%  In any case the quantiser is symmetrical about zero.

if step <= 0, q = x; return, end

if nargin <= 2, rise1 = step/2; end

luma_table = [
    [16 11 10 16 24 40 51 61]
    [12 12 14 19 26 58 60 55]
    [14 13 16 24 40 57 69 56]
    [14 17 22 29 51 87 80 62]
    [18 22 37 56 68 109 103 77]
    [24 35 55 64 81 104 113 92]
    [49 64 78 87 103 121 120 101]
    [72 92 95 98 112 100 103 99]
    ];

sz = length(x);
q = zeros(size(x));

step = step * luma_table;
rise1 = rise1 * luma_table;

ind = reshape(reshape(1:sz,M,sz/M)',1,sz);
t = 1:sz/M;

for i=1:8
    r = ind(i*t);
    for j=1:8
        c = ind(j*t);
        q(r,c) = max(0,ceil((abs(x(r,c)) - rise1(i,j))/step(i,j))) .* sign(x(r,c));
    end
end
