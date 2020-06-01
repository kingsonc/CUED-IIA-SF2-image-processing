function ssimval=SSim(Z,X,diffShow)
[ssimval,ssimmap] = ssim(Z,X);
if diffShow==true
    imshow(ssimmap,[]);
    title(['Local SSIM Map with Global SSIM Value: ',num2str(ssimval)])
end
end