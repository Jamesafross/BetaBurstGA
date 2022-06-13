function TF = mf_tfcm(sig,ncw_init,freq,fs,is_vary_ncw,ncw_step,E_type)
% mf_tfcm    return time-frequency representation of a input signal,convoluted by complex morlet's wavelets. 
%Usage
%   TF = mf_tfcm(sig,ncw_init,freq,fs,is_vary_ncw,ncw_step,E_type)
%Inupts
%   sig -- a vector
%   ncw_init -- see mf_cmorlet        
%   freq -- a digit or a vector,freqs will be analyzed.
%       if digit TF is a vector,
%       if vector,TF is a matrix.
%   fs -- sampling rate
%	is_vary_ncw,ncw_step -- see mf_cmorlet
%   E_type -- returned energy type.one of the following
%       'coef'
%       'amplitude': abs(coef)
%       'power': abs(coef).^2
%       'db':10*log10(abs(coef).^2)
%see also mf_cmorlet

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Wu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

if nargin~=7
    disp('mf_tfcm requires 7 arguments!');
    return;
end

sig = sig(:)'; %convert to row vector
len_sig = length(sig);
len_freq = length(freq);
ts = 1/fs; %sample period

%%%initialize output coefficients matrix
TF = zeros(len_freq,len_sig);

%%%compute TF
for i=1:len_freq
    cm = mf_cmorlet( freq(i),fs,ncw_init,is_vary_ncw,ncw_step );
    temp = conv_srz(sig,cm);
    TF(i,:) = temp( [1:len_sig] + (length(cm)-1)/2 );
end
clear temp;

switch E_type 
    case 'coef'
        TF = TF;
    case 'amplitude'
        TF = abs(TF);
    case 'power'
        TF = abs(TF).^2;
    case 'db'
        TF = 10*log10( abs(TF).^2 );
end
