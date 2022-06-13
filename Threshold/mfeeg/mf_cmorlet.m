function y = mf_cmorlet(f0,fs,ncw_init,is_vary_ncw,ncw_step)
%mf_cmorlet     complex morlet's wavelet. which has a Gaussian shape in both time domain and frequency domain around its central frequency f0.  
%   =  (SD_t*sqrt(pi))^(-1/2) * exp( -t.^2/(2*SD_t^2) ) .* exp(i*2*pi*f0*t)
%   SD_t: a standard deviation. The wavelet duaration is defined as SD_t*2. SD_t is
%   half wave width. 
%   SD_f: in frequency.same as SD_t in time.
%	Ref: Tallon-Baudry et al, 1996.
%Usage
%   y = mf_cmorlet(f0,fs,ncw_init,is_vary_ncw,ncw_step)
%Input
%   f0 -- central frequency. digit
%   fs -- sample rate
%   ncw_init -- number of cycles in wavelet. which determine a wavelet family. increasing it results in
%       better frequency resolution in expense of the time resolution.
%		for fixed ncw, this is for all frequency. for varying ncw, this is for 20 Hz.
%		digit.
%	is vary_ncw -- 0: fixed ncw. 1: varying ncw.
%	ncw_step -- step for linearly increasing ncws.
%See manual for more backgroud and explanation.
%Use mf_cmorlet_character to check how ncw is varied. Also simply use mf_cmorlet_range to get freq and time width given a frequency and a ncw.
% sample useage. ncw_init=6 and ncw_step=0.21 is OK for most cases.
% to see the produced wavelet,
%y=mf_cmorlet(10,500,6,1,0.21);figure;plot(real(y))
%y=mf_cmorlet(40,500,6,1,0.21);figure;plot(real(y))

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Wu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com         
%-------------------------------------------------------------------------

if nargin~=5
    disp('mf_cmorlet requires 5 arguments!');
    return;
end

ts = 1/fs; %sample period, second

ncw_freq = get_ncw(ncw_init,is_vary_ncw,ncw_step); % get ncw of 1-200Hz

% produce SD_f and SD_t of f0, of obtained ncw
SD_f = f0/ncw_freq(f0);  
SD_t = 1/(2*pi*SD_f);

t = [0:ts:5*SD_t]; % half length of wavelet used for analysis.  more long, more precisely, but slower, 5 is used here
t = [-t(end:-1:2) t]; %whole length, plus negative part

% produce morlet's wavelet. original Tallon-Baudry code
%y = ( SD_t*sqrt(pi) )^(-1/2) * exp( -t.^2/(2*SD_t^2) ) .* exp( i*2*pi*f0*t );

% produce morlet's wavelet. spm code.
% according to spm5 (spm_eeg_morlet), FWHM = sqrt(8*log(2))*SD_t, this scaling factor is
% proportional to Tallon-Baudry, which is small.
y = exp( -t.^2/(2*SD_t^2) ) .* exp( 1i*2*pi*f0*t );
y = y./(sqrt(0.5*sum( real(y).^2 + imag(y).^2 )));


function ncw_freq = get_ncw(ncw_init,is_vary_ncw,ncw_step)
% vary_ncw		get ncws of frequencies. 
%	default frencncy 1-200 Hz, which is suitable for most cases.
% Usage -- ncw_freq = get_ncw(ncw_init,is_vary_ncw,ncw_step)
% Input
%	ncw_init -- for fixed ncw, this is for all frequency. for varying ncw, this is for 20 Hz.
%	is vary_ncw -- 0: fixed ncw. 1: varying ncw.
%	ncw_step -- step for linearly increasing ncws.
% Output
%	ncws of 1-200Hz.


if nargin~=3
    disp('get_ncw requires 3 arguments!');
    return;
end

ncw_freq = zeros(1,200); % frequency 1~200

if is_vary_ncw==0
	ncw_freq(:) = ncw_init;
end

if is_vary_ncw==1
	for i=1:200
		% my step
		ncw_freq(i) = (i-20)*ncw_step + ncw_init; 
	end
end
