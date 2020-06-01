%% create .mat file
clear all;

load SF2_competition_image_2020.mat;
X = double(X);

[vlc, qstep, bits, huffval] = encoder(X);

save sf2_2020cmp.mat vlc qstep bits huffval

%% decode image

clear all;

load sf2_2020cmp.mat;

fprintf(1, 'Number of bits %i\n', vlctest(vlc));

Z = decoder(vlc, qstep, bits, huffval);

save sf2_2020dec.mat Z;

load SF2_competition_image_2020.mat;
X = double(X);
fprintf(1, 'RMS error %f\n', std(X(:) - Z(:)));
fprintf(1, 'SSIM %f\n', SSim(Z,X,false));

draw(beside(X,Z));