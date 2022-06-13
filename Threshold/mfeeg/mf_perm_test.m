function [pval,pval_correct] = mf_perm_test(matrix1,matrix2,shuffle_num,is_paired,c_ch)
% matrix row-ch, column-subject

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Xu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

if (nargin ~= 5)
    disp('mf_perm_test requires 5 input arguments!')
	return
end

[o,p] = size(matrix1);
matrix_cat = cat(3,matrix1,matrix2); % last dim - condition
clear matrix1;
clear matrix2;

% pval (uncorrect)
pval = zeros(1,o);
for i = 1:o
	[h,pval(i)] = ttest(matrix_cat(i,:,1)-matrix_cat(i,:,2));
	if (mean(matrix_cat(i,:,1))-mean(matrix_cat(i,:,2))) < 0
		pval(i) = -pval(i);
	end
end

oo = length(c_ch);

pval_correct = zeros(1,o);
tval_distribution = zeros(1,shuffle_num);

% tval
dif_tmp = matrix_cat(:,:,1) - matrix_cat(:,:,2);
tval = (mean(dif_tmp,2) ./ ( std(dif_tmp,0,2) ./ sqrt(p) ))';

% correct
shuffle_sub_num = round(p/2);
for k = 1:shuffle_num
	tmp = matrix_cat(c_ch,:,:);

	if is_paired == 1
		shuffle_sub = mf_rand_norep([1,shuffle_sub_num],1,p,1);
		tmp1 = matrix_cat(c_ch,shuffle_sub,1);
		tmp2 = matrix_cat(c_ch,shuffle_sub,2);
		matrix_cat(c_ch,shuffle_sub,1) = tmp2;
		matrix_cat(c_ch,shuffle_sub,2) = tmp1;
	end
	if is_paired == 0
		tmp = reshape(tmp,[oo,p*2]);
		tmp = shuffle_eeglab(tmp,2);
		tmp = reshape(tmp,[oo p 2]);
	end

	dif_tmp = tmp(:,:,1) - tmp(:,:,2);
	tval_tmp = (mean(dif_tmp,2) ./ ( std(dif_tmp,0,2) ./ sqrt(p) ))';

	pos_tval_tmp = tval_tmp( find(tval_tmp>=0) );
	max_pos_tval_tmp = max(pos_tval_tmp);
	neg_tval_tmp = tval_tmp( find(tval_tmp<0) );
	max_neg_tval_tmp = -max(abs(neg_tval_tmp));
	if max_pos_tval_tmp > abs(max_neg_tval_tmp)
		max_tval_tmp = max_pos_tval_tmp;
	else
		max_tval_tmp = max_neg_tval_tmp;
	end
	if isempty(max_tval_tmp)
		max_tval_tmp = 0;
	end
	tval_distribution(k) = max_tval_tmp;
end

tval_distribution = sort(tval_distribution);

% pval_correct
for i = 1:o
	if tval(i)>=0
		pval_correct(i) = length( find(tval_distribution>=tval(i)) ) / shuffle_num;
	else
		pval_correct(i) = -length( find(tval_distribution<=tval(i)) ) / shuffle_num;
	end
end

