function [pval,statval] = mf_erpstat_oneway_anova(erp_group_cell)
% mf_erpstat_oneway_anova	statis  groups of erp data using oneway anova (repeated measures).
%	[pval,statval] = mf_erpstat_oneway_anova(erp_group_cell)
% Input
%   erp_group_cell -- earch erp_group: ch*time*sbj
% Output
%	p value and F value.
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
    disp('mf_erpstat_oneway_anova requires 1 input arguments!')
	return
end

condition_level_num = length(erp_group_cell);
[m,n,o] = size(erp_group_cell{1}); % o: sbj_num

%%%%% pval
pval = zeros(m,n);
statval = zeros(m,n);


% calculate
for i = 1:m
    fprintf('%d ',i);
    if mod(i,16) == 0
        fprintf('\n');
    end
    
    for j = 1:n
        data_tmp = zeros(o,condition_level_num);
        for k = 1:condition_level_num
            erp_group_tmp = erp_group_cell{k};
            vect_tmp = erp_group_tmp(i,j,:);
            vect_tmp = reshape(vect_tmp,o,1);
            data_tmp(:,k) = vect_tmp;
        end 
        data_tmp = data_tmp(:);
        
        condition_order = zeros(o,condition_level_num);
        for kk = 1:condition_level_num
            condition_order(:,kk) = kk;
        end
        condition_order = condition_order(:);
        
        sbj_order = (1:o)';
        sbj_order = repmat(sbj_order,condition_level_num,1);
        
        [p,table,stats] = anovan(data_tmp,{condition_order,sbj_order},'varnames',{'condition','sbj'},'model','full','random',2,'display','off');
        pval(i,j) = table{2,7};
        statval(i,j) = table{2,6};
    end
end





