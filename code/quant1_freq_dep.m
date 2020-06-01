function q = quant1_freq_dep(x, step, rise1, N)

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

% luma_table = [
%     [4 6 7 8 10 13 18 31]
%     [6 9 10 12 15 20 28 48]
%     [7 10 12 14 18 23 32 55]
%     [8 12 14 17 21 27 38 65]
%     [10 15 18 21 26 33 47 80]
%     [13 20 23 27 33 43 61 103]
%     [18 28 32 38 47 61 86 146]
%     [31 48 55 65 80 103 146 250]
%     ];

sz = length(x);
q = zeros(size(x));

step = step * luma_table;
rise1 = rise1 * luma_table;

ind = reshape(reshape(1:sz,N,sz/N)',1,sz);

for i=1:N
    r = ind((i-1)*sz/N+1:i*sz/N);
    for j=1:N
        c = ind((j-1)*sz/N+1:j*sz/N);
        q(r,c) = max(0,ceil((abs(x(r,c)) - rise1(i,j))/step(i,j))) .* sign(x(r,c));
    end
end
