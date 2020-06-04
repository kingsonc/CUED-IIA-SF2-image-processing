qstep = 0.66;

[vlc, bits, huffval] = jpegenc_dwt(X-128, qstep, 5, false, 10);
Z = jpegdec_dwt(vlc, qstep, 5, bits, huffval, 10);
Z = Z + 256;

fprintf(1, 'RMS error %f\n', std(X(:) - Z(:)));
fprintf(1, 'SSIM %f\n', SSim(Z,X,false));
