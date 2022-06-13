function [freq_width,time_width] = mf_cmorlet_range(f0,ncw)
%mf_cmorlet_range     given a frequency and a ncw, return freqency and time width of the morlet wavelet.  
%Usage
%   y = mf_cmorlet_range(f0,ncw)
%Input
%   f0 -- a frequency. digit.
%   ncw -- number of cycles in wavelet. 
%Output
%	freqency and time width of the morlet wavelet
%see also mf_cmorlet for more explanation.

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Wu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com         
%-------------------------------------------------------------------------	
if nargin~=2
    disp('mf_cmorlet_range requires 2 arguments!');
    return;
end

freq_width = 2*f0/ncw;  
time_width = 2*1/(2*pi*(freq_width/2));
