function [pval,statval] = mf_erpstat_2sample_ttest_paired(erp_group1,erp_group2)
% mf_erpstat_2sample_ttestt_paired	statis two group erp data using paired t-test.
%	[pval,statval] = mf_erpstat_2sample_ttestt_paired(erp_group1,erp_group2)
% Output
%	There are positive (group1>group2) and negtive
%		(group1<group2) values.
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
    disp('mf_erpstat_2sample_ttestt_paired requires 2 input arguments!')
	return
end

[m,n,o] = size(erp_group1);

%%%%% pval
pval = zeros(m,n);
statval = zeros(m,n);


% calculate
for i = 1:m
    for j = 1:n
        vect1 = erp_group1(i,j,:);
        vect1 = reshape(vect1,1,o);
        vect2 = erp_group2(i,j,:);
        vect2 = reshape(vect2,1,o);
            
            
        [h,pval(i,j),ci,stats] = ttest(vect1,vect2);
        if mean(vect1)-mean(vect2) < 0
            pval(i,j) = -pval(i,j);
        end
        statval(i,j) = stats.tstat;
            
    end
end





