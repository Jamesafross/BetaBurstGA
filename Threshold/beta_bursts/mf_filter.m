function y = mf_filter(vector,filter_type,pass_type,cutoff,order,fs)
%mf_filter      butterworth IIR filter, used on a vector. (now just do IIR. In practice, this filter is much better than FIR filter, e.g., that used in spm.
%Usage
%   y = mf_filter(vector,filter_type,pass_type,cutoff,order,fs)
%Input
%	vector
%   filter_type -- 'IIR'.( no 'FIR' now)
%   pass_type -- 'low pass','high pass','band pass','band stop'
%   cutoff -- low pass and high pass,scalar;band pass and band stop,a two elements vector
%	order -- use even rather than odd numbers. usually, 4 is ok for most case, like epoch from 400 ms to 2s. (you might check the results, use 6 or 2 if not good. You also might exame it using freqz.)

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Wu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

if nargin~=6
    disp('mf_filter requires 6 input arguments!')
	return
end

freq_norm = cutoff/(fs/2);
%%%IIR%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if filter_type=='IIR'
    switch pass_type
        case 'low pass'
            [b,a] = butter(order,freq_norm);
        case 'high pass'
            [b,a] = butter(order,freq_norm,'high');
        case 'band pass'
            [b,a] = butter(order/2,freq_norm);
        case 'band stop'
            [b,a] = butter(order/2,freq_norm,'stop');
    end
end

%y = filter(b,a,vector);
y = filtfilt(b,a,vector); % zero phase

%%%FIR%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
