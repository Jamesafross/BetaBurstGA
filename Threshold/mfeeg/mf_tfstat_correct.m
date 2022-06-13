function pval = mf_tfstat_correct(tf_group1,tf_group2,shuffle_num,correct_method,c_ch,c_freq,c_time)
% mf_tfstat		statis two group tf data using paired t-test or paired wilcoxon.
%	correction based on voxel in TF.
%	now just t-test
% Usage		
%	pval = mf_tfstat(tf_group1,tf_group2,shuffle_num,correct_method,c_ch,c_freq,c_time)
% Input
%	correct_method -- 1:ch 2:F-T 3:ch-F-T 4:ch-F 5:ch-T
%	c_ch,c_freq,c_time 
% Output
%	pval -- P values. There are positive (tf_group1>tf_group2) and negtive
%		(tf_group1<tf_group2) values.

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Xu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

if (nargin ~= 7)
    disp('mf_tfstat_correct requires 7 input arguments!')
	return
end

[m,n,o,p] = size(tf_group1);
tf_group = cat(5,tf_group1,tf_group2); % last dim -- condition
clear tf_group1;
clear tf_group2;

mm = length(c_freq); nn = length(c_time); oo = length(c_ch);

tval = zeros(m,n,o);
pval = zeros(m,n,o);
tval_distribution = zeros(1,shuffle_num);

% tval
dif_tmp = tf_group(:,:,:,:,1) - tf_group(:,:,:,:,2);
tval = mean(dif_tmp,4) ./ ( std(dif_tmp,0,4) ./ sqrt(p) );


% ---------------------- correct for electrode -------------------------
if correct_method==1
	fprintf('\n');
	
	for i = 1:m
		fprintf('%d ',i);
		for j = 1:n
		
			% tval_distribution
			for k = 1:shuffle_num
				tmp = tf_group(i,j,c_ch,:,:);  
				tmp = squeeze(tmp); % o p 2
				tmp = reshape( tmp,[oo p*2] ); % o p*2, data struct for shuffle (electrodes)*(subject*condition)
				tmp = shuffle_eeglab(tmp,2); % shuffle p*2
				tmp = reshape(tmp,[oo p 2]); % o p 2
			
				dif_tmp = tmp(:,:,1) - tmp(:,:,2); % o p
				tval_tmp = mean(dif_tmp,2) ./ ( std(dif_tmp,0,2) ./ sqrt(p) ); % o
			
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
		
			% pval
			for l = 1:o
				if tval(i,j,l)>=0
					pval(i,j,l) = length( find( tval_distribution>=tval(i,j,l) ) ) / shuffle_num;
				else
					pval(i,j,l) = -length( find( tval_distribution<=tval(i,j,l) ) ) / shuffle_num;
				end
			end
		
		end
		
	end
	
	fprintf('\n');
end
% ----------------------------------------------------------------

% --------------------correct for time and frequency -------------
if correct_method==2
	fprintf('\n');
	
	for i = 1:o
		fprintf('\n%d ',i);
		
		% tval_distribution
		for k = 1:shuffle_num 
			tmp = tf_group(c_freq,c_time,i,:,:);
			tmp = squeeze(tmp); % m n p 2
			tmp = reshape( tmp,[mm nn p*2] ); % (m*n)*(p*2), data struct for shuffle (f*t)*(subject*condition)
			tmp = shuffle_eeglab(tmp,3); % shuffle p*2
			tmp = reshape(tmp,[mm nn p 2]); % m n p 2
			
			dif_tmp = tmp(:,:,:,1) - tmp(:,:,:,2); % m n p
			tval_tmp = mean(dif_tmp,3) ./ ( std(dif_tmp,0,3) ./ sqrt(p) ); % m n
				
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
		
		% pval
		for j = 1:m
			for jj = 1:n
				if tval(j,jj,i)>=0
					pval(j,jj,i) = length( find( tval_distribution>=tval(j,jj,i) ) ) / shuffle_num;
				else
					pval(j,jj,i) = -length( find( tval_distribution<=tval(j,jj,i) ) ) / shuffle_num;
				end
			end
		end	
		
	end

	fprintf('\n');
end
% ----------------------------------------------------------------

% --------------------correct for ch and time and frequency -------------
if correct_method==3
	fprintf('\n');
	
	% tval_distribution
	for k = 1:shuffle_num
		if mod(k,100) == 0 
			fprintf('%d ',k);
		end
		tmp = tf_group(c_freq,c_time,c_ch,:,:);
		tmp = reshape( tmp,[mm nn oo p*2] ); % (m*n*o)*(p*c), data struct for shuffle (f*t*o)*(subject*condition)
		tmp = shuffle_eeglab(tmp,4); % shuffle p*2
		tmp = reshape(tmp,[mm nn oo p 2]); % m n o p 2
			
		dif_tmp = tmp(:,:,:,:,1) - tmp(:,:,:,:,2); % m n o p
		tval_tmp = mean(dif_tmp,4) ./ ( std(dif_tmp,0,4) ./ sqrt(p) ); % m n o
				
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
		
	% pval 
    fprintf('\n');
	for i = 1:m
		fprintf('%d ',i);
		for j = 1:n
			for l = 1:o
				if tval(i,j,l)>=0
					pval(i,j,l) = length( find( tval_distribution>=tval(i,j,l) ) ) / shuffle_num;
				else
					pval(i,j,l) = -length( find( tval_distribution<=tval(i,j,l) ) ) / shuffle_num;
				end
			end
		end
	end
	
	fprintf('\n');	
end
% ----------------------------------------------------------------

% --------------------correct for ch and frequency -------------
if correct_method==4
	fprintf('\n');
	
	for i = 1:n
		if mod(i,100) == 0 
			fprintf('%d ',i);
		end
		
		% tval_distribution
		for k = 1:shuffle_num 
			tmp = tf_group(c_freq,i,c_ch,:,:);
			tmp = squeeze(tmp); % m o p 2
			tmp = reshape( tmp,[mm oo p*2] ); % (m*o)*(p*2), data struct for shuffle (f*ch)*(subject*condition)
			tmp = shuffle_eeglab(tmp,3); % shuffle p*2
			tmp = reshape(tmp,[mm oo p 2]); % m o p 2
			
			dif_tmp = tmp(:,:,:,1) - tmp(:,:,:,2); % m o p
			tval_tmp = mean(dif_tmp,3) ./ ( std(dif_tmp,0,3) ./ sqrt(p) ); % m o
				
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
		
		% pval
		for j = 1:m
			for jj = 1:o
				if tval(j,i,jj)>=0
					pval(j,i,jj) = length( find( tval_distribution>=tval(j,i,jj) ) ) / shuffle_num;
				else
					pval(j,i,jj) = -length( find( tval_distribution<=tval(j,i,jj) ) ) / shuffle_num;
				end
			end
		end
		
	end

	fprintf('\n');
end
% ----------------------------------------------------------------

% --------------------correct for ch and time -------------
if correct_method==5
	fprintf('\n');
	
	for i = 1:m
		fprintf('%d ',i);
		
		% tval_distribution
		for k = 1:shuffle_num 
			tmp = tf_group(i,c_time,c_ch,:,:);
			tmp = squeeze(tmp); % n o p 2
			tmp = reshape( tmp,[nn oo p*2] ); % (n*o)*(p*2), data struct for shuffle (t*ch)*(subject*condition)
			tmp = shuffle_eeglab(tmp,3); % shuffle p*2
			tmp = reshape(tmp,[nn oo p 2]); % n o p 2
			
			dif_tmp = tmp(:,:,:,1) - tmp(:,:,:,2); % n o p
			tval_tmp = mean(dif_tmp,3) ./ ( std(dif_tmp,0,3) ./ sqrt(p) ); % n o
				
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
		
		% pval
		for j = 1:n
			for jj = 1:o
				if tval(i,j,jj)>=0
					pval(i,j,jj) = length( find( tval_distribution>=tval(i,j,jj) ) ) / shuffle_num;
				else
					pval(i,j,jj) = -length( find( tval_distribution<=tval(i,j,jj) ) ) / shuffle_num;
				end
			end
		end
		
	end

	fprintf('\n');
end
% ----------------------------------------------------------------



