function [aps,faxis] = mf_eegaps(eeg,fs)
%
% mf_eegaps	return the auto power spectrum, using welch method.
%	also see mf_eegcoh_2ch.
% Usage	[aps,faxis] = mf_eegaps(eeg,fs)

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
    disp('mf_eegaps requires 2 arguments!');
    return;
end

[m,n,o] = size(eeg);

%parameter of matlab psd function, u can modify here if need
nwindow = []; % default 8 window
noverlap = []; % default 50% ovelap
% nfft	
%	the length of returned Psd or f is nfft/2+1 when nfft is even, or (nfft+1)/2 when nfft is odd. 
%	the range of returned f is [0,fs/2].
%	the length of returned psd or f should > fs/2+1, so that
%		every frequency at least has a psd value.
%	normaly, the fs we used are 250,500,1000. so we define correspanding nfft is 
%		256,512,1024 (power of 2). in this method, the length of returned psd or f is nfft/2+1 
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

aps = zeros(o,len_Psd);

for i=1:o
	for j=1:m
		[aps_tmp,faxis] = pwelch( eeg(j,:,i),nwindow,noverlap,nfft,fs ); %psd
		aps_tmp = aps_tmp(:)'; % return of pwelch is a column
		aps_tmp = aps_tmp.*fs; %convert psd to ps
		aps(i,:) = aps(i,:) + aps_tmp;
	end
end

aps = aps/m;

faxis = faxis(:)';


