function y = mf_epormb(epo,base)
% mf_epormb remove base line from epo.
%Usage
%   y = mf_epormb(epo,base)
%Input
%	base -- the time interval for baseline.

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
    disp('mf_epormb requires 2 arguments!');
    return;
end
[m,n,o] = size(epo);
y = zeros(m,n,o);

for i=1:o
    for j=1:m
        y(j,:,i) = epo(j,:,i) - mean( epo(j,base,i) );
    end
end

