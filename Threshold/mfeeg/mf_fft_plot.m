function y = mf_fft_plot(sig,samp_rate)
%y = mf_fft_plot(sig,samp_rate,plot_frequency_range)
% calculate fft and plot data in time and frequency domain 

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Xu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

if (nargin ~= 2)
    disp('mf_fft_plot requires 2 input arguments!')
	return
end

sig = sig(:)'; %convert to row vector
len_sig = length(sig);
y = fft(sig)/len_sig; % Normalize by /len_sig. Furthermore, abs should be abs*2 in later analyses.


% plot    
t=(0:len_sig-1)/samp_rate;
f=samp_rate/2*linspace(0,1,round(len_sig/2)); % before Nyquist frequency
%f=f(50:300);

subplot(211),plot(t,sig);
xlabel('time (second)');

y_amplitude = abs(y)*2; %
y_amplitude = 10*log10(y_amplitude+1);
subplot(212),plot(f,y_amplitude(1:length(f)));
xlabel('frequency (Hz)');

%zoom on;

