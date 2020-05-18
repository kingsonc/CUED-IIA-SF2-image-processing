N = 8;
I = length(X);

C = dct_ii(N);
[Pf, Pr] = pot_ii(N);
t = [(1+N/2):(I-N/2)];

%% POT pre-filter then DCT
Xp = X; 
Xp(t,:) = colxfm(Xp(t,:), Pf);
Xp(:,t) = colxfm(Xp(:,t)', Pf)';

Y = colxfm(colxfm(Xp,C)',C)';

%% inverse DCT then POT post-filter
Z = colxfm(colxfm(Y',C')',C');
Zp = Z;
Zp(:,t) = colxfm(Zp(:,t)', Pr')'; 
Zp(t,:) = colxfm(Zp(t,:), Pr');

%% optimise step size for every POT scaling factor
N = 8;
I = length(X);
C = dct_ii(N);
t = [(1+N/2):(I-N/2)];
direct_quant_rms_err = 4.9340;

scaling_data = [];

for pot_scale = 1:0.01:2
    [Pf, Pr] = pot_ii(N,pot_scale);
    Xp = X;
    Xp(t,:) = colxfm(Xp(t,:), Pf);
    Xp(:,t) = colxfm(Xp(:,t)', Pf)';
    Y = colxfm(colxfm(Xp,C)',C)';
    
    best_diff_rms_err = 100;
    best_step_size = 0;
    for step_size = 15:0.01:30
        Yq = quantise(Y, step_size);

        Z = colxfm(colxfm(Yq',C')',C');
        Zp = Z;
        Zp(:,t) = colxfm(Zp(:,t)', Pr')'; 
        Zp(t,:) = colxfm(Zp(t,:), Pr');

        rms_err = std(X(:) - Zp(:));
        if abs(rms_err - direct_quant_rms_err) < best_diff_rms_err
            best_diff_rms_err = abs(rms_err - direct_quant_rms_err);
            best_step_size = step_size;
        end
    end
    
    Yq = quantise(Y, best_step_size);
    Yr = regroup(Yq,N);
    bits = dctbpp(Yr, N);
    
    scaling_data(cast(pot_scale * 100, 'uint8'), :) = [best_step_size, best_diff_rms_err, bits];
end

%% compression ratio and draw
Yq = quantise(Y, best_step_size);
Yr = regroup(Yq,N);

bits = dctbpp(Yr, 16);
disp(bits);

Z = colxfm(colxfm(Yq',C')',C');
Zp = Z;
Zp(:,t) = colxfm(Zp(:,t)', Pr')'; 
Zp(t,:) = colxfm(Zp(t,:), Pr');
draw(Zp);

%% basis
bases = [zeros(1,8); Pf'; zeros(1,8)]; 
draw(255*bases(:)*bases(:)');

%% pre-filterd image
draw(Xp * 0.5);
