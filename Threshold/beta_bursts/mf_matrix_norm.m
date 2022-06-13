function matrix_norm = mf_matrix_norm(matrix,base,norm_method)
% mf_matrix_norm  normalize on 2-D matrix.
% Usage
%   matrix_norm = mf_matrix_norm(matrix,base,norm_method)
% Input
%	matrix -- 2D matrix
%	base -- same as mf_eegrmb
% norm_method 1 x - mean(base) 
%			  2 (x - mean(base)) / std(base) 					
%			  3 (x - mean(base)) / mean(base) * 100		% that's ERS/ERD

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Wu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

if nargin~=3
    disp('mf_matrix_norm requires 3 arguments!');
    return;
end

[m,n] = size(matrix);
MEAN = mean( matrix(:,base),2 );
STD = std( matrix(:,base),0,2 );

if norm_method == 1
    matrix_norm = (matrix-repmat(MEAN,1,n));
end
if norm_method == 2
    matrix_norm = (matrix-repmat(MEAN,1,n)) ./ repmat(STD,1,n);
end
if norm_method == 3
    matrix_norm = (matrix-repmat(MEAN,1,n)) ./ repmat(MEAN,1,n) * 100;
end
