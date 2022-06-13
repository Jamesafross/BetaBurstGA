function masked_tf = mf_tf_mask_zero(tf,criterion_size)
% mf_tf_mask_zero	mask continuous non-zero data points in tf as zero, if their size is < criterion_size.
%   Usage: masked_tf = mf_tf_mask_zero(tf,criterion_size)
%   Main usage: e.g., when presenting statistical maps, only areas at least 30 (input size) continuous data point (10 ms if 500 sample rate and 3 Hz in 1Hz steps) is considered significant.
% Input
%   criterion_size -- number of continuous data points 
% Also see mf_matrix_mask_zero.
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
    disp('mf_tf_mask_zero requires 2 input arguments!')
	return
end

[m,n,o] = size(tf);
masked_tf=zeros(m,n,o);

for i = 1:o
    masked_tf(:,:,i) = mf_matrix_mask_zero(tf(:,:,i),criterion_size);
end





