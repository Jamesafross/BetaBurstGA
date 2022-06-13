function y = mf_rawfilter(cnt,filter_type,pass_type,cutoff,order,fs)
%mf_rawfilter      return filted rawdata
%Usage
%   y = mf_cntfilter(cnt,filter_type,pass_type,cutoff,order,fs)
%see also see also mf_filter

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Xu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com     
%-------------------------------------------------------------------------

if nargin~=6
    disp('mf_rawfilter requires 6 input arguments!')
	return
end

[m,n] = size(cnt);
y = zeros(m,n);
tmp = [];

for i=1:n
     y(:,i) = mf_filter( cnt(:,i)',filter_type,pass_type,cutoff,order,fs )';
end

clear tmp;
