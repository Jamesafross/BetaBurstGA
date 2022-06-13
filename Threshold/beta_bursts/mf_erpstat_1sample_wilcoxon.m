function [pval,statval] = mf_erpstat_1sample_wilcoxon(erp_group)
% mf_erpstat_1sample_wilcoxon	statis data using one sample wilcoxon.
%	pval = mf_erpstat_1sample_wilcoxon(erp_group)
% Output
%	There are positive (group>0) and negtive
%		(group<0) values.
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
if nargin~=1
    disp('mf_erpstat_1sample_wilcoxon requires 1 input arguments!')
	return
end

[m,n,o] = size(erp_group);

%%%%% pval
pval = zeros(m,n);
statval = zeros(m,n);


% calculate
for i = 1:m
    for j = 1:n
        vect1 = erp_group(i,j,:);
        vect1 = reshape(vect1,1,o);
            
        [pval(i,j),h,stats] = signrank(vect1);
        if mean(vect1) < 0
            pval(i,j) = -pval(i,j);
        end
        statval(i,j)=stats.signedrank;
        if mean(vect1) < 0
            statval(i,j) = -statval(i,j);
        end            
            
    end
end





