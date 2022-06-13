function y = mf_plot(x,time)
%mf_plot    for plotting vector according time(second)
%Usage
%   y = mf_plot(x,time)
%Input
%   x -- a vector
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

if nargin~=2
    disp('mf_plot requires 2 arguments!');
    return;
end

plot(t,x);

y = 0;
