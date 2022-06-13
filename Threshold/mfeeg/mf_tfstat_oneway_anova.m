function [pval,statval] = mf_tfstat_oneway_anova(tf_group_cell)
% mf_tfstat_oneway_anova	statis  groups of tf data using oneway anova (repeated measures).
%	[pval,statval] = mf_tfstat_oneway_anova(tf_group_cell)
% Input
%   tf_group_cell -- earch tf_group: freq*time*ch*sbj
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
    disp('mf_tfstat_oneway_anova requires 1 input arguments!')
	return
end

condition_level_num = length(tf_group_cell);
[m,n,o,p] = size(tf_group_cell{1}); % p: sbj_num

%%%%% pval
pval = zeros(m,n,o);
statval = zeros(m,n,o);


% calculate
for i = 1:o
    fprintf('%d ',i);
    fprintf('\n');
    
    for j = 1:m
        fprintf('%d ',j)
        if mod(j,16) == 0
            fprintf('\n');
        end
		if j==m
			fprintf('\n');
		end
        
        for q = 1:n
            
            data_tmp = zeros(p,condition_level_num);
            for k = 1:condition_level_num
                tf_group_tmp = tf_group_cell{k};
                vect_tmp = tf_group_tmp(j,q,i,:);
                vect_tmp = reshape(vect_tmp,p,1);
                data_tmp(:,k) = vect_tmp;
            end
            data_tmp = data_tmp(:);
            
            condition_order = zeros(p,condition_level_num);
            for kk = 1:condition_level_num
                condition_order(:,kk) = kk;
            end
            condition_order = condition_order(:);
            
            sbj_order = (1:p)';
            sbj_order = repmat(sbj_order,condition_level_num,1);
            
            [pp,table,stats] = anovan(data_tmp,{condition_order,sbj_order},'varnames',{'condition','sbj'},'model','full','random',2,'display','off');
            pval(j,q,i) = table{2,7};
            statval(j,q,i) = table{2,6};
        end
    end
end





