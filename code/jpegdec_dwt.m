function Z = jpegdec_dwt(vlc, qstep, N, bits, huffval, dcbits, W, H)

% JPEGDEC Decodes a (simplified) JPEG bit stream to an image
%
%  Z = jpegdec_dwt(vlc, qstep, N, bits, huffval, dcbits, W, H) Decodes the
%  variable length bit stream in vlc to an image in Z.
%
%  vlc is the variable length output code from jpegenc
%  qstep is the quantisation step to use in decoding
%  N is the numer of DWT levels (defaults to 3)
%
%  if bits and huffval are supplied, these will be used in Huffman decoding
%  of the data, otherwise default tables are used
%  dcbits determines how many bits are used to decode the DC coefficients
%  of the DCT (defaults to 8)
%  W and H determine the size of the image (defaults to 256 x 256)
%
%  Z is the output greyscale image

% Presume some default values if they have not been provided
narginchk(2, 8);
opthuff = true;
if (nargin<8)
    H = 256;
    W = 256;
    if (nargin<6)
        dcbits = 8;
        if (nargin<5)
            opthuff = false;
            if (nargin<3)
                N = 3;
            end
        end
    end
end

% Set up standard scan sequence
M = 2^N;
scan = diagscan(M);

if (opthuff)
    disp('Generating huffcode and ehuf using custom tables')
else
    disp('Generating huffcode and ehuf using default tables')
    [bits, huffval] = huffdflt(1);
end

% Define starting addresses of each new code length in huffcode.
huffstart=cumsum([1; bits(1:15)]);
% Set up huffman coding arrays.
[huffcode, ehuf] = huffgen(bits, huffval);

% Define array of powers of 2 from 1 to 2^16.
k=[1; cumprod(2*ones(16,1))];

% For each block in the image:

% Decode the dc coef (a fixed-length word)
% Look for any 15/0 code words.
% Choose alternate code words to be decoded (excluding 15/0 ones).
% and mark these with vector t until the next 0/0 EOB code is found.
% Decode all the t huffman codes, and the t+1 amplitude codes.

eob = ehuf(1,:);
run16 = ehuf(15*16+1,:);
i = 1;
Zq = zeros(H, W);
t=1:M;

disp('Decoding rows')
for r=0:M:(H-M)
    for c=0:M:(W-M)
        yq = zeros(M,M);
        
        % Decode DC coef - assume no of bits is correctly given in vlc table.
        cf = 1;
        if (vlc(i,2)~=dcbits) 
            error('The bits for the DC coefficient does not agree with vlc table'); 
        end
        yq(cf) = vlc(i,1) - 2^(dcbits-1);
        i = i + 1;
        
        % Loop for each non-zero AC coef.
        while any(vlc(i,:) ~= eob)
            run = 0;
            
            % Decode any runs of 16 zeros first.
            while all(vlc(i,:) == run16), run = run + 16; i = i + 1; end
            
            % Decode run and size (in bits) of AC coef.
            start = huffstart(vlc(i,2));
            res = huffval(start + vlc(i,1) - huffcode(start));
            run = run + fix(res/16);
            cf = cf + run + 1;  % Pointer to new coef.
            si = rem(res,16);
            i = i + 1;
            
            % Decode amplitude of AC coef.
            if vlc(i,2) ~= si
                error('Problem with decoding .. you might be using the wrong bits and huffval tables');
            end
            ampl = vlc(i,1);
            
            % Adjust ampl for negative coef (i.e. MSB = 0).
            thr = k(si);
            yq(scan(cf-1)) = ampl - (ampl < thr) * (2 * thr - 1);
            
            i = i + 1;
        end
        
        % End-of-block detected, save block.
        i = i + 1;
        
        Zq(r+t,c+t) = yq;
    end
end

% Un-regroup
Zq = dwtgroup(Zq, -N);

fprintf(1, 'Inverse quantising to step size scaling of %i\n', qstep);
Zi=quant2_dwt(Zq, N, qstep);

fprintf(1, 'Inverse %i level DWT\n', N);
Z = nlevidwt(Zi, N);

return