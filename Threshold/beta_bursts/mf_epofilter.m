function y = mf_epofilter(epo,filter_type,pass_type,cutoff,order,fs)
%mf_epofilter   filt epo
%Usage
%   y = mf_epofilter(epo,filter_type,pass_type,cutoff,order,fs)
%Input
% epo -- epoch file
%	see also mf_filter
% Output
% return filtered epo

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
    disp('mf_epofilter requires 6 input arguments!')
	return
end

[m,n,o] = size(epo);
y = zeros(m,n,o);
for i=1:o
    for j=1:m
        y(j,:,i) = mf_filter( epo(j,:,i),filter_type,pass_type,cutoff,order,fs );
    end
end



