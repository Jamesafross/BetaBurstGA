function TF = mf_stft(sig, samp_rate, freq_analyze, is_plot)
%TF = mf_stft(sig, samp_rate, freq_analyze, is_plot)
%
%return time-frequency distribution calculated with STFT.
%use hanning widow
%window width is according freq_analyze,
%window width = 7/(2*pi*freq_analyze)*2*1000 ms
%step = 1
%if_plot:1--plot,0--not plot 

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Xu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

if (nargin ~= 4)
    disp('mf_stft requires 4 input arguments!')
	return
end

sig = sig(:)';

step = 1;
samp_period = 1/samp_rate *1000;%采样周期 ms

window_width = round( 7/(2*pi*freq_analyze)*2*1000/samp_period );% 跨越多少个采样点
window = hanning(window_width)';

length_sig = length(sig);

row_TF = ceil(window_width/2);
column_TF = ceil(length_sig/step);
TF = zeros(row_TF,column_TF);

if (window_width/2 == round(window_width/2))
	window_center = window_width/2;
	padding_left = window_width - window_center + 1;
	padding_right = window_width - window_center;
else
	window_center = (window_width+1)/2;
	padding_left = window_width - window_center;
	padding_right = window_width - window_center;
end
sig_padding = [zeros(1,padding_left), sig, zeros(1,padding_right)];

for i = 1:step:length_sig
    sig_cut = sig_padding( i:(i+window_width-1) ) .* window;
    temp = fft(sig_cut)';
    TF(:,i) = temp(1:row_TF);
end

%plot
%colormap('gray');
if is_plot==1
    y_interval = samp_rate/window_width;
    x_interval = step*samp_period;
    imagesc([0:x_interval:(column_TF-1)*x_interval], [0:y_interval:(row_TF-1)*y_interval], abs(TF).^2);
    title('TF (energy)');
    xlabel('time (ms)');
    ylabel('frequency (Hz)');
    axis('xy');%?
    colorbar('vert');
    shading flat;%?
    zoom on;
end

%TF的行列，窗宽需要取整
