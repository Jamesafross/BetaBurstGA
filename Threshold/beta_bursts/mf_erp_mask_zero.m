function masked_erp = mf_erp_mask_zero(erp,criterion_length)
% mf_erp_mask_zero	mask continuous non-zero data points as zero, if their length is < criterion_length.
%   Main usage: e.g., when presenting statistical maps, only at least 10 (input length) continuous data point (20 ms if 500 sample rate) is considered significant.
% Input
%   crterion_length -- number of continuous data points 
% Also see mf_vector_mask_zero.
%
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
    disp('mf_erp_mask_zero requires 2 input arguments!')
	return
end

[m,n] = size(erp);
masked_erp=zeros(m,n);

for i = 1:m
    masked_erp(i,:)=mf_vector_mask_zero(erp(i,:),criterion_length);
end





