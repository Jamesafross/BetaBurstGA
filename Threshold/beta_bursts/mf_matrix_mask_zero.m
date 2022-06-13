function masked_matrix = mf_matrix_mask_zero(matrix,criterion_size)
% masked_matrix = mf_matrix_mask_zero(matrix,criterion_size)
% mask continuous non-zero values in a matrix as zero, if their size is < criterion_size. the matrix can be 2, 3 or even high demention.

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
    disp('mf_matrix_mask_zero requires 2 input arguments!')
	return
end

BW=logical(matrix);

cc = bwconncomp(BW);
stats = regionprops(cc, 'Area');
idx = find([stats.Area] >= criterion_size);
BW2 = ismember(labelmatrix(cc), idx);

masked_matrix = matrix .* BW2;


