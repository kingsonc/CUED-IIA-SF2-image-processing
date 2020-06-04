for qstep=5.2:0.01:100
    [vlc, bits, huffval] = jpegenc_lbt(X-128, qstep, 4, 16, true, true);
    if sum(vlc(:,2)) <= (40960-1424)
        break
    end
end

Z = jpegdec_lbt(vlc, qstep, 4, 16, true, bits, huffval);
Z = Z + 128;

fprintf(1, 'RMS error %f\n', std(X(:) - Z(:)));
fprintf(1, 'SSIM %f\n', SSim(Z,X,false));
