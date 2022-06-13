function pval = mf_tfstat(tf_group1,tf_group2,stat_method,cluster_size)
% mf_tfstat	 statis two group tf data using paired t-test or paired wilcoxon.
%	pval = mf_tfstat(tf_group1,tf_group2,stat_method,cluster_size)
% Input
%   stat_method -- 'pt': paired t-test. quick.
%                  'pw': paired wilcoxon. slow. 
% 	cluster_size -- the step of time point.
% Output
%	pval -- P values. There are positive (tf_group1>tf_group2) and negtive
%		(tf_group1<tf_group2) values.
% See also mf_erpstat

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Xu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

[m,n,o,p] = size(tf_group1);

%%%%% pval
pval = zeros(m,n,o);

% prolong the sample point to the most small multiple of cluster_size,
%   residual is padded by zero
if mod(n,cluster_size) == 0
    n_pad = n;
else
    n_pad = n - mod(n,cluster_size) + cluster_size;
end
tf_group1_pad = zeros(m,n_pad,o,p);
tf_group1_pad(:,1:n,:,:) = tf_group1;
tf_group2_pad = zeros(m,n_pad,o,p);
tf_group2_pad(:,1:n,:,:) = tf_group2;
pval_pad = zeros(m,n_pad,o);

% make new tf_group and pval according to cluster number
cluster_num = n_pad/cluster_size;
tf_group1_cluster = zeros(m,cluster_num,o,p);
tf_group2_cluster = zeros(m,cluster_num,o,p);
for i = 1:cluster_num
    tmp = tf_group1_pad( :,((i-1)*cluster_size+1):i*cluster_size,:,: );
    tf_group1_cluster(:,i,:,:) = mean(tmp,2);
    tmp = tf_group2_pad( :,((i-1)*cluster_size+1):i*cluster_size,:,: );
    tf_group2_cluster(:,i,:,:) = mean(tmp,2);
end
pval_cluster = zeros(m,cluster_num,o);

% calculate
for i = 1:o
    fprintf('%d ',i);
    fprintf('\n');
    if mod(i,16) == 0 
        fprintf('\n');
    end
    for j = 1:m
        fprintf('%d ',j)
        for k = 1:cluster_num
            vect1 = tf_group1_cluster(j,k,i,:);
            vect1 = reshape(vect1,1,p);
            vect2 = tf_group2_cluster(j,k,i,:);
            vect2 = reshape(vect2,1,p);
            
            if stat_method == 'pw'
                pval_cluster(j,k,i) = signrank(vect1,vect2);
                if mean(vect1)-mean(vect2) < 0
                    pval_cluster(j,k,i) = -pval_cluster(j,k,i);
                end
            end
            
            if stat_method == 'pt'
                [h,pval_cluster(j,k,i)] = ttest(vect1-vect2);
                if mean(vect1)-mean(vect2) < 0
                    pval_cluster(j,k,i) = -pval_cluster(j,k,i);
                end
            end
            
        end
    end
    fprintf('\n');
end

% convert pval_cluster to pval and cut the residual
for i = 1:cluster_num
    tmp = repmat( pval_cluster(:,i,:),[1,cluster_size,1] ); 
    pval_pad( :,((i-1)*cluster_size+1):i*cluster_size,: ) = tmp;
end

pval = pval_pad(:,1:n,:);


