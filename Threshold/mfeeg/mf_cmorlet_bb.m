function y = mf_cmorlet(f0,fs,ncw)
%mf_cmorlet     complex morlet's wavelet  
%	!!!!!!need modify manually at two location,
%		1 if vary ncw
%		2 how ncw change
%   =  (SD_t*sqrt(pi))^(-1/2) * exp( -t.^2/(2*SD_t^2) ) .* exp(i*2*pi*f0*t)
%   which have a Gaussian shape both in the time domain and in the
%   frequency domain around its central frequency f0.
%   ncw: number of cycles in wavelet
%   SD_t: a standard deviation. The wavelet duaration is define SD_t*2. SD_t is
%   half wave width. 
%   SD_f: in frequency.same as SD_t.
%Usage
%   y = mf_cmorlet(f0,fs,ncw)
%Input
%   f0 -- central frequency
%   fs -- sample rate
%   ncw -- which determine a wavelet family.increasing which results in
%       better frequency resolution in expense of the time resolution.
%Ref: Tallon-Baudry et al

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify
% Welcome to find bugs,propose improvements, and discuss with author
%
% wu xiang     http://mail.ustc.edu.cn/~rwfwu/mfeeg/mfeeg.html
%              rwfwu@ustc.edu or rwfwu@yahoo.com.cn           
%-------------------------------------------------------------------------

if nargin~=3
    disp('mf_cmorlet requires 3 arguments!');
    return;
end

ts = 1/fs; %sample period, second

ncw_freq = vary_ncw(ncw,1); %!!! using varied or constant ncw, assigned here!!!.

SD_f = f0/ncw_freq(f0);  
SD_t = 1/(2*pi*SD_f);

% according to spm5, FWHM = sqrt(8*log(2))*SD_t
t = [0:ts:5*SD_t];
t = [-t(end:-1:2) t];

%y = ( SD_t*sqrt(pi) )^(-1/2) * exp( -t.^2/(2*SD_t^2) ) .* exp( 1i*2*pi*f0*t );

y = exp( -t.^2/(2*SD_t^2) ) .* exp( 1i*2*pi*f0*t );
% according to spm5, this scaling factor is proportional to Tallon-Baudry
y = y./(sqrt(0.5*sum( real(y).^2 + imag(y).^2 )));


function ncw_freq = vary_ncw(ncw,is_vary)
%	traditional using constant ncw results in too coarse time resolution for low 
%		frequency and too coarse frequency resolution for high frequency. 
%		so according to	eeglab, ncw should increase slowly with frequency.
%	In eeglab, ncw=3 for 6Hz and ncw=9 for 35Hz. the step is (9-3)/(35-6).
%		the step is too large. for 40 Hz, ncw=7, using this step, the ncw of frequency
%		below 6Hz are all negtive.normaly, ncw = 7 for 40 Hz, suggest by Tollan-Baudry et al. 
%	so we define how the ncw increase with frequency as:
%		if frequency = 40, ncw = 7; if frequency = 6, ncw = 3. the increase step of 
%		ncw with frequency (ncw_step) thus be (7-3)/(40-6). the ncw of 1~100Hz then 
%		be (frequency-40)*ncw_step + 7. 
%	Input
%		the input ncw -- is ncw of 40 Hz. ncw of other frequency is defined by the above method.
%		is_vary -- 0, using traditional constant ncw. 1, using varied ncw discribe here.
%	Output
%		ncw_freq -- ncw of all frequency varied.

ncw_freq = zeros(1,100); % frequency 1~100

if is_vary==0
	ncw_freq(:) = ncw;
end

if is_vary==1
	% step of ncw
	ncw_step = (7-3)/(40-6); % my step. may be little
%	ncw_step = (9-3)/(35-6); % eeglab step. good

	% ncw of all frequencies
	for i=1:100
		% my step
		ncw_freq(i) = (i-40)*ncw_step + ncw; %  input ncw 7; ncw=7 at 40Hz. lowest fequency is 0 Hz.
		
		% eeglab step
%		ncw_freq(i) = (i-35)*ncw_step + ncw; %  default of eeglab. input ncw 9; ncw=9 at 35 Hz. lowest frequency is 0 Hz.
		%ncw_freq(i) = (i-35)*ncw_step + ncw -2.0345; % input ncw 9; but ncw=8 at 40 Hz. lowest frequency is 2 Hz.
%		ncw_freq(i) = (i-35)*ncw_step + ncw -3.0345; % input ncw 9; but ncw=7 at 40 Hz. lowest frequency is 7 Hz.
	end
end
