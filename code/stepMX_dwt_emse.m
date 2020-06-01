function stepMX= stepMX_dwt_emse(n)
% find step size ratio matrix
%  s is sclaing factor, R is ssz ratio matrix   
    dwtSszRatio=zeros(3,n+1);
    for i=1:n+1
        if i==n+1
            Xt=zeros(256,256); Yt=nlevdwt(Xt,n);
            mid=256/(2^i);%note an extra 2 here at level n
            %set center of the subimage equal to 100
            Yt(mid,mid)=100;
            Xtr=nlevidwt(Yt,n);
            dwtSszRatio(1,i)=1/sqrt(sum(Xtr(:).^2));
            
        else
            for k=1:3
            Xt=zeros(256,256); Yt=nlevdwt(Xt,n);
            mid=256/(2^i);
            %set center of the subimage equal to 100
            Yt(mid+((-1)^(k-1))*(mid/2),mid+(2-2*abs(k-2.5))*(mid/2))=100;
            Xtr=nlevidwt(Yt,n);
            dwtSszRatio(k,i)=1/sqrt(sum(Xtr(:).^2)); %step size=1/root(tot energy)
            end
        end
    end
   
    %stepMX=(1/dwtSszRatio(1,1))*dwtSszRatio;

    stepMX=(1/min(nonzeros(dwtSszRatio)))*dwtSszRatio;