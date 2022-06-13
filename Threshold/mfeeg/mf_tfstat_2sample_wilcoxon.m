function [pval,statval] = mf_tfstat_2sample_wilcoxon(tf_group1,tf_group2)
% mf_tfstat_2sample_wilcoxon	statis two group tf data using wilcoxon.
%	[pval,statval] = mf_tfstat_2sample_wilcoxon(tf_group1,tf_group2)
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
    disp('mf_tfstat_2sample_wilcoxon requires 2 input arguments!')
	return
end

[m,n,o,p] = size(tf_group1);

%%%%% pval
pval = zeros(m,n,o);
statval = zeros(m,n,o);


% calculate
for i = 1:o
    fprintf('%d ',i);
    fprintf('\n');

    for j = 1:m
        fprintf('%d ',j);
        if mod(j,16) == 0
            fprintf('\n');
        end
        for k = 1:n
            vect1 = tf_group1(j,k,i,:);
            vect1 = reshape(vect1,1,p);
            vect2 = tf_group2(j,k,i,:);
            vect2 = reshape(vect2,1,p);
  
            
            [pval(j,k,i),h,stats] = signrank(vect1,vect2);
            if mean(vect1)-mean(vect2) < 0
                pval(j,k,i) = -pval(j,k,i);
            end
            
            statval(j,k,i)=stats.signedrank;
            if mean(vect1)-mean(vect2) < 0
                statval(j,k,i) = -statval(j,k,i);
            end  
            
        end
    end
    fprintf('\n');
end



