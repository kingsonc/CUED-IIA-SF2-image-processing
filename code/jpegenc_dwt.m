function [vlc, bits, huffval] = jpegenc_dwt(X, qstep, N, opthuff, dcbits)

% JPEGENC Encode an image to a (simplified) JPEG bit stream
%
%  [vlc bits huffval] = jpegenc_dwt(X, qstep, N, opthuff, dcbits) Encodes the
%  image in X to generate the variable length bit stream in vlc.
%
%  X is the input greyscale image
%  qstep is the quantisation step to use in encoding
%
%  N is the numer of DWT levels (defaults to 3)
%
%  if opthuff is true (defaults to false), the Huffman table is optimised
%  based on the data in X
%  dcbits determines how many bits are used to encode the DC coefficients
%  of the DCT (defaults to 8)
%
%  vlc is the variable length output code, where vlc(:,1) are the codes, and
%  vlc(:,2) the number of corresponding valid bits, so that sum(vlc(:,2))
%  gives the total number of bits in the image
%  bits and huffval are optional outputs which return the Huffman encoding
%  used in compression

% This is global to avoid too much copying when updated by huffenc
global huffhist  % Histogram of usage of Huffman codewords.

% Presume some default values if they have not been provided
narginchk(2, 5);
if ((nargout~=1) && (nargout~=3))
    error('Must have one or three output arguments');
end
if (nargin<5)
    dcbits = 8;
    if (nargin<4)
        opthuff = false;
        if (nargin<3)
            N = 3;
        end
    end
end
if ((opthuff==true) && (nargout==1))
    error('Must output bits and huffval if optimising huffman tables');
end

% DWT on input image X.
fprintf(1, 'Forward %i level DWT\n', N);
Y = nlevdwt(X-128, N);

% Quantise to integers.
fprintf(1, 'Quantising to step size scaling of %i\n', qstep);
[Yq, ~, entbits] = quant1_dwt(Y, N, qstep);

fprintf(1, 'Bits from entropy = %f\n', entbits);

% Regroup
Yq = dwtgroup(Yq, N);

% Generate zig-zag scan of AC coefs.
M = 2^N;
scan = diagscan(M);

% On the first pass use default huffman tables.
disp('Generating huffcode and ehuf using default tables')
[dbits, dhuffval] = huffdflt(1);  % Default tables.
[~, ehuf] = huffgen(dbits, dhuffval);

% Generate run/ampl values and code them into vlc(:,1:2).
% Also generate a histogram of code symbols.
disp('Coding rows')
sy=size(Yq);
t = 1:M;
huffhist = zeros(16*16,1);
vlc = [];
for r=0:M:(sy(1)-M)
    vlc1 = [];
    for c=0:M:(sy(2)-M)
        yq = Yq(r+t,c+t);
        % Encode DC coefficient first
        yq(1) = yq(1) + 2^(dcbits-1);
        if ((yq(1)<0) | (yq(1)>(2^dcbits-1)))
            error('DC coefficients too large for desired number of bits');
        end
        dccoef = [yq(1)  dcbits];
        % Encode the other AC coefficients in scan order
        ra1 = runampl(yq(scan));
        vlc1 = [vlc1; dccoef; huffenc(ra1, ehuf)]; % huffenc() also updates huffhist.
    end
    vlc = [vlc; vlc1];
end

% Return here if the default tables are sufficient, otherwise repeat the
% encoding process using the custom designed huffman tables.
if (opthuff==false)
    if (nargout>1)
        bits = dbits;
        huffval = dhuffval;
    end
    fprintf(1,'Bits for coded image = %d\n', sum(vlc(:,2)));
    return;
end

% Design custom huffman tables.
disp('Generating huffcode and ehuf using custom tables')
[dbits, dhuffval] = huffdes(huffhist);
[~, ehuf] = huffgen(dbits, dhuffval);

% Generate run/ampl values and code them into vlc(:,1:2).
% Also generate a histogram of code symbols.
disp('Coding rows (second pass)')
t = 1:M;
huffhist = zeros(16*16,1);
vlc = [];
for r=0:M:(sy(1)-M)
    vlc1 = [];
    for c=0:M:(sy(2)-M)
        yq = Yq(r+t,c+t);
        % Encode DC coefficient first
        yq(1) = yq(1) + 2^(dcbits-1);
        dccoef = [yq(1)  dcbits];
        % Encode the other AC coefficients in scan order
        ra1 = runampl(yq(scan));
        vlc1 = [vlc1; dccoef; huffenc(ra1, ehuf)]; % huffenc() also updates huffhist.
    end
    vlc = [vlc; vlc1];
end
fprintf(1,'Bits for coded image = %d\n', sum(vlc(:,2)))
fprintf(1,'Bits for huffman table = %d\n', (16+max(size(dhuffval)))*8)

if (nargout>1)
    bits = dbits;
    huffval = dhuffval';
end

return
