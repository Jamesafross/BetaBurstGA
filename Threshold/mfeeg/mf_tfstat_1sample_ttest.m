function [pval,statval] = mf_tfstat_1sample_ttest(tf_group)
% mf_tfstat_1sample_ttest	statis  data using one sample t-test.
%	[pval,statval] = mf_tfstat_1sample_ttest(tf_group)
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
    disp('mf_tfstat_1sample_ttest requires 1 input arguments!')
	return
end

[m,n,o,p] = size(tf_group);

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
            vect1 = tf_group(j,k,i,:);
            vect1 = reshape(vect1,1,p);
  
            
            [h,pval(j,k,i),ci,stats] = ttest(vect1);
            if mean(vect1) < 0
                pval(j,k,i) = -pval(j,k,i);
            end
            statval(j,k,i) = stats.tstat;
            
        end
    end
    fprintf('\n');
end



