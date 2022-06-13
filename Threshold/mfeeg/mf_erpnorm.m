function y = mf_erpnorm(erp,base,norm_method)
% Usage
%   y = mf_erpnorm(erp,base,norm_method)
% Input
% base, norm_method -- see mf_vector_norm

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Xu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

if nargin~=3
    disp('mf_erpnorm requires 3 arguments!');
    return;
end
[o,n] = size(erp);
y = zeros(o,n);

for i=1:o
    y(i,:) = mf_vector_norm(erp(i,:),base,norm_method);
end
