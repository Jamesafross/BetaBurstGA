function [coh,faxis] = mf_eegcoh_2ch(eeg,ch1,ch2,fs)
%
% mf_eegcoh_2ch	return coherence of two electrodes.
% Usage	[coh,faxis] = mf_eegcoh_2ch(eeg,ch1,ch2,fs)
%	the traditional coherence in EEG literature. coherence is the frequency domain
%		equivalent to the cross-covariance function (xcorr), which measure the similarity of 
%		two signals in frequency domain.
%	coherence have no time information, different from event-related coherence (see mf_eegsync).
%		calulated using Fourier transform.
%	consider two signal x,y. 
%		X, Y are the fourier transform of x,y. X = fft(x), Y = fft(y). 
%		Sxy is corss-spectrum. Sxy = X .* conj(Y).
%		Sxx, Syy are power-spectrum. Sxx = X.*conj(X) = abs(X)^2. Syy = Y.*conj(Y) = abs(Y)^2.
%		Cxy is coherence between x and y. Cxy = abs(Sxy)^2 / (Sxx .* Syy)
%		the above x, y are single trial,in this instance, mf_eegcoh_2ch is same as mscohere(cohere) in matlab. 
%	for n trials, i = 1:n. there are x(i), y(i).
%		then there are X(i), Y(i), Sxy(i), Sxx(i), Syy(i).
%		Cxy = abs( mean(Sxy(i)) )^2 / ( mean(Sxx(i)) .* mean(Syy(i)) )
%	coherence between 0 ~ 1.
%	while we will use the welch method. corss-spectrum and power spectrum can using
%		matlab bilt-in function pwelch and cpsd. pwelch and cpsd calculate power(cross) spectrum density,
%		which * fs will get power(cross) spectrum. whose parameter can be modified in file 
%			(I think the default values are ok.except for nfft).
%		(cohere and mscohere can calulated coherence for single trial, but not for n trials. cohere.m is 
%		not bilt-in function, can for reference.
%	note in different papers or sofaxiswares, the names of cross-spectrum, power spectrum and the signs of 
%		them are different.
%	

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Xu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

if nargin~=4
    disp('mf_eegcoh_2ch requires 4 arguments!');
    return;
end

[m,n,o] = size(eeg);

x = eeg(:,:,ch1);
y = eeg(:,:,ch2);


%%%%%-------------------welch realization---------------------
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
%{
if fs==250
	nfft = 256;
end
if fs==500
	nfft = 512;
end
if fs==1000
	nfft = 1024;
end
%}
nfft = fs;

len_Psd = nfft/2+1;
%[Ptt,faxis] = pwelch( x(1,:),nwindow,noverlap,nfft,fs ); % to get the lengen of returned stectrum density

Sxy = zeros( len_Psd,1 );
Sxx = zeros( len_Psd,1 );
Syy = zeros( len_Psd,1 );

for i=1:m
	[Pxy,faxis] = cpsd( x(i,:),y(i,:),nwindow,noverlap,nfft,fs ); %psd
	Pxy = Pxy.*fs; %convert psd to ps
	Sxy = Sxy + Pxy;

	[Pxx,faxis] = pwelch( x(i,:),nwindow,noverlap,nfft,fs ); %psd
	Pxx = Pxx.*fs; %convert psd to ps
	Sxx = Sxx + Pxx;

	[Pyy,faxis] = pwelch( y(i,:),nwindow,noverlap,nfft,fs ); %psd
	Pyy = Pyy.*fs; %convert psd to ps
	Syy = Syy + Pyy;
end

%%%%%----------------end welch realization

Sxy = Sxy/m;
Sxx = Sxx/m;
Syy = Syy/m;

SxxSyy = Sxx.*Syy;
zero = find( SxxSyy==0 );
SxxSyy(zero) = 1;
coh = abs(Sxy).^2 ./ SxxSyy;
coh(zero) = 0;

coh = coh(:)';
faxis = faxis(:)';


