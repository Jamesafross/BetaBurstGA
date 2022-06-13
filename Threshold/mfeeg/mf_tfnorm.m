function y = mf_tfnorm(tf,base,norm_method) 
%mf_tfnorm	Normalize on tf file.
%Usage
%   y = mf_tfnorm(tf,base,norm_method) 
% Input
% norm_method see mf_matrix_norm
%	base -- see mf_matrix_norm
% Output
%	Normalized tf file.

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
    disp('mf_tfrmb requires 3 arguments!');
    return;
end

[m,n,o] = size(tf);
y = zeros(m,n,o);

for i=1:o
    y(:,:,i) = mf_matrix_norm( tf(:,:,i),base,norm_method );
end
