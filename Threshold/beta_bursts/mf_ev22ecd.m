function y = mf_ev22ecd(ev2file)
%mf_ev22em	get event code information from neuroscan ev2 file.
%Usage
%   y = mf_ev22ecd(ev2file)
%Inupt
%  ev2 file -- event code file of neuroscan. column 2 is events, column 6 is sample points.
%Output
%  y -- event code file (ecd). column 1 is events, column 2 is sample points.

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Wu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

ev2 = load(ev2file);
[m,n] = size(ev2);

y = zeros(m,2);
y(:,1) = ev2(:,2);
y(:,2) = ev2(:,6);

