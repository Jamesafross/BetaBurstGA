function y = mf_image(x,freq,time)
%mf_image    for image matrix according time(second)
%Usage
%   y = mf_image(x,freq,time)
%Input
%   x -- a matrix
%   freq -- a vector,frequencies 
%   time -- a vector,the time points of sample points according zero(stimuli)
%Output
%   y -- 0(not return a meaning value)

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Xu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

if nargin~=3
    disp('mf_image requires 3 arguments!');
    return;
end
colormap(jet(256));
%bar_scale = [-1 1]*max(max(x));
imagesc(time, freq, x, bar_scale);
%imagesc(time, freq, x);
%image(x);
title('');
xlabel('time (second)');
ylabel('frequency (Hz)');
axis('xy');
colorbar('vert');
    
