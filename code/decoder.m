function Z = decoder(vlc, qstep, bits, huffval)

Z = jpegdec_dwt(vlc, qstep, 5, bits, huffval);
Z = rescale(Z, 0, 255, 'InputMin', -256, 'InputMax', 0);

end
