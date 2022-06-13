function y = mf_epoavg(epo)
%mf_epoavg	get erp, by average epochs.
%Usage
%   y = mf_epoavg(epo)
%Output
%   erp

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Wu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

if nargin~=1
    disp('mf_epoavg requires 1 input arguments!')
	return
end

[m,n,o] = size(epo);

%init erp
y = zeros(o,n);

%product erp
for i=1:o
    y(i,:) = mean( epo(:,:,i),1 );
end





