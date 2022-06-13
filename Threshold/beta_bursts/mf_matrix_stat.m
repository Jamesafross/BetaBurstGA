function [pval,p_criterion] = mf_matrix_stat(tf_matrix_group1,tf_matrix_group2,stat_method,cluster_size)
% Usage
%	[pval,p_criterion] = mf_matrix_stat(tf_matrix_group1,tf_matrix_group2,stat_method,cluster_size)

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Xu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

[m,n,p] = size(tf_matrix_group1);

%%%%% pval
pval = zeros(m,n);

% prolong the sample point to the most small multiple of cluster_size,
%   residual is padded by zero
if mod(n,cluster_size) == 0
    n_pad = n;
else
    n_pad = n - mod(n,cluster_size) + cluster_size;
end
tf_matrix_group1_pad = zeros(m,n_pad,p);
tf_matrix_group1_pad(:,1:n,:) = tf_matrix_group1;
tf_matrix_group2_pad = zeros(m,n_pad,p);
tf_matrix_group2_pad(:,1:n,:) = tf_matrix_group2;
pval_pad = zeros(m,n_pad);

% make new matrix_group and pval according to cluster number
cluster_num = n_pad/cluster_size;
tf_matrix_group1_cluster = zeros(m,cluster_num,p);
tf_matrix_group2_cluster = zeros(m,cluster_num,p);
for i = 1:cluster_num
    tmp = tf_matrix_group1_pad( :,((i-1)*cluster_size+1):i*cluster_size,: );
    tf_matrix_group1_cluster(:,i,:) = mean(tmp,2);
    tmp = tf_matrix_group2_pad( :,((i-1)*cluster_size+1):i*cluster_size,: );
    tf_matrix_group2_cluster(:,i,:) = mean(tmp,2);
end
pval_cluster = zeros(m,cluster_num);

% calculate

for j = 1:m
    for k = 1:cluster_num
        vect1 = tf_matrix_group1_cluster(j,k,:);
        vect1 = reshape(vect1,1,p);
        vect2 = tf_matrix_group2_cluster(j,k,:);
        vect2 = reshape(vect2,1,p);
            
        if stat_method == 'pw'
            pval_cluster(j,k) = signrank(vect1,vect2);
            if mean(vect1)-mean(vect2) < 0
                pval_cluster(j,k) = -pval_cluster(j,k);
            end
        end
            
        if stat_method == 'pt'
            [h,pval_cluster(j,k)] = ttest(vect1-vect2);
            if mean(vect1)-mean(vect2) < 0
                pval_cluster(j,k) = -pval_cluster(j,k);
            end
        end
            
    end
end


% convert pval_cluster to pval and cut the residual
for i = 1:cluster_num
    tmp = repmat( pval_cluster(:,i),[1,cluster_size] ); 
    pval_pad( :,((i-1)*cluster_size+1):i*cluster_size ) = tmp;
end

pval = pval_pad(:,1:n);

%%%%% p_criterion
p_criterion = pval;
p_001_pos = find( p_criterion>=0 & p_criterion<=0.01 );
p_005_pos = find( p_criterion>0.01 & p_criterion<=0.05 );
p_01_pos = find( p_criterion>0.05 & p_criterion<=0.1 );
%p_02_pos = find( p_criterion>0.1 & p_criterion<=0.2 );
p_001_neg = find( p_criterion<0 & p_criterion>=-0.01 );
p_005_neg = find( p_criterion<-0.01 &p_criterion>=-0.05 );
p_01_neg = find( p_criterion<-0.05 &p_criterion>=-0.1 );
%p_02_neg = find( p_criterion<-0.1 &p_criterion>=-0.2 );

p_criterion(:)=0;
%p_criterion(p_02_pos) = 1;
p_criterion(p_01_pos) = 1;
p_criterion(p_005_pos) = 2;
p_criterion(p_001_pos) = 3;
%p_criterion(p_02_neg) = -1;
p_criterion(p_01_neg) = -1;
p_criterion(p_005_neg) = -2;
p_criterion(p_001_neg) = -3;



