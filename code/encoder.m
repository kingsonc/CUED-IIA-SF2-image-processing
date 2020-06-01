function [vlc, qstep, bits, huffval] = encoder(X)

for qstep=1.5:0.01:10
    try
        [vlc, bits, huffval] = jpegenc_dwt(X-128, qstep, 5, true);
        if sum(vlc(:,2)) <= (40960-1424)
            break
        end
    catch
        continue
    end
end
