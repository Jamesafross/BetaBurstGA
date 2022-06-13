function [psd,faxis] = mf_eegpsd(eeg,fs)
%
% mf_eegpsd	power spectrum density. according to matlab, psd is power spectrum / fs.
%	the more bacground see mf_eegcoh.

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Xu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

if nargin~=2
    disp('mf_eegpsd requires 2 arguments!');
    return;
end

[m,n,o] = size(eeg);

%parameter of matlab psd function, u can modify here if need
nwindow = []; % default 8 window
noverlap = []; % default 50% ovelap
	% nfft	
	%	the length of returned Psd or f is = fs/2 +1. nfft/2+1 when even, or (nfft+1)/2 when odd. 
	%	the range of returned f is [0,fs/2].
	%	so at least, the length of returned psd should > the length returned f, so that
	%		every frequency has a psd value.
	%	normaly, the fs we used are 250,500,1000. so we define correspanding nfft is 
	%		256,512,1024 (power of 2).
if fs==250
	nfft = 256;
end
if fs==500
	nfft = 512;
end
if fs==1000
	nfft = 1024;
end

len_Psd = nfft/2+1;
%[Ptt,faxis] = pwelch( x(1,:,1),nwindow,noverlap,nfft,fs ); % to get the lengen of returned stectrum density

Psd = zeros( o,len_Psd );

for i=1:o
	for j=1:m
		[Pxx,faxis] = pwelch( x(i,:,j),nwindow,noverlap,nfft,fs ); %psd
		Psd(i,:) = Psd(i,:) + Pxx';
	end
	Psd(i,:) = Psd(i,:)/m;
end

faxis = faxis';
