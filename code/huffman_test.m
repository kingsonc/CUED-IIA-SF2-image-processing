% direct_quant_rms_err = 4.9340;  % lighthouse
% direct_quant_rms_err = 4.8759;  % bridge
direct_quant_rms_err = 4.8882;  % flamino

best_diff_rms_err = 100;
best_step_size = 0;
best_bits = 0;

for qstep = 19.6:0.01:19.8
    [vlc, bits, huffval] = jpegenc_lbt(X-128, qstep, 4, 16, false, true);
    Z = jpegdec_lbt(vlc, qstep, 4, 16, false, bits, huffval);
    
%     [vlc, bits, huffval] = jpegenc_dwt(X-128, qstep, 5, true, 10);
%     Z = jpegdec_dwt(vlc, qstep, 5, bits, huffval, 10);
    
    rms_err = std(X(:) - Z(:));
    if abs(rms_err - direct_quant_rms_err) < best_diff_rms_err
        best_diff_rms_err = abs(rms_err - direct_quant_rms_err);
        best_step_size = qstep;
        best_bits = sum(vlc(:,2));
    end
end

disp(best_diff_rms_err);
disp(best_step_size);
disp(best_bits);
