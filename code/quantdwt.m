function [Yq, dwtent, bits] = quantdwt(Y, n, step_size)

% k = 1: top right
% k = 2: bottom left
% k = 3: bottom right

m = length(Y);

dwtstep_equal_mse = [
    [23.13478978 15.08682074 8.227499092 4.212081361 2.118952058 1.061067185]
    [23.13478978 15.08682074 8.227499092 4.212081361 2.118952058 1.061067185]
    [16.7106087 13.02861017 7.573280788 3.94700953 1.994644192 1]
];

dwtstep = ones(3, n+1) * step_size;  % Constant step size
% dwtstep = dwtstep_equal_mse * step_size;  % Equal MSE

dwtent = zeros(3, n+1);

Yq = Y;
bits = 0;

for i=1:n
    w = m/(2^(i-1)); 
    for k=1:3
        switch k
            case 1
                tr = 1:w/2;
                tc = (w/2)+1:w;
            case 2
                tr = (w/2)+1:w;
                tc = 1:w/2;
            case 3
                tr = (w/2)+1:w;
                tc = (w/2)+1:w;
        end
        Yq(tr,tc) = quantise(Y(tr,tc), dwtstep(k,i));
        dwtent(k,i) = bpp(Yq(tr,tc));
        bits = bits + bpp(Yq(tr,tc)) * length(tr) * length(tc);
    end
end

% quantise final low-pass
w = m/(2^n);
tr = 1:w/2;
tc = (w/2)+1:w;
Yq(tr,tc) = quantise(Y(tr,tc), dwtstep(1,n+1));
dwtent(1,n+1) = bpp(Yq(tr,tc));
bits = bits + bpp(Yq(tr,tc)) * length(tr) * length(tc);
