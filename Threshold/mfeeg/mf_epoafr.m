function y = mf_epoafr(epo,point_reject,criterion,ch_afr,file_in_out,is_pp,sample_rate)
%mf_epoafr     reject epochs with artifact. artifact here refers to votage above a criterion.
%Usage
%   function y = mf_epoafr(epo,point_reject,criterion,ch_afr,file_in_out,is_pp,sample_rate)
% Input
%	epo -- epoch file
%	point_reject -- reject trial according the time interval assigned by point_reject, which does not has to be the whole epoch.
%	criterion -- usually, 50 for short epoch, 75 or 100 for long epoch.
%   ch_afr -- digit or vector. electrodes that are used to reject artifact. Usually are heog and vehg, or plus frontal electrodes. if votage at heog or veog is above a criterion, the epochs of all electrodes are rejected.
%   file_in_out -- a file records how many trials are input and how many trials are output.
%	is_pp -- 0 or 1, wether pre-process before afr. low frequency drift is supposed to be kept but impacts the artifact reject. better to pre-process like filter and detrend before aft, but put low frequency drift back after afr for further analyses. By default, a filter 1~25 Hz is used, plus baseline removement. 
%	sample_rate 
%Output
%   return epo without artifact.

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Wu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

if nargin~=7
    disp('mf_epoafr requires 6 input arguments!')
	return
end

if is_pp == 1
[m,n,o] = size(epo);
% pre-process before afr, remove drift by filter (or & and rmb)
	epo_pp = mf_epofilter(epo,'IIR','band pass',[1,25],4,sample_rate);
	%epo_pp = mf_epodtr(epo_pp);
	epo_pp = mf_epormb(epo_pp,1:n);
end
if is_pp ==0
	epo_pp = epo;
end

epo_afr = epo_pp(:,point_reject,:);
clear epo_pp;
[m,n,o] = size(epo_afr);
fprintf('input %d trials:   ',m);
fid_w = fopen(file_in_out,'w');
fprintf(fid_w,'criterion %d uv\n',criterion);
fprintf(fid_w,'input %d trials\n',m);

%product index of trials whose value of ch according ch_afr between - criterion
%   and criterion
index = [];
len_ch_afr = length(ch_afr);
for i=1:m
    if len_ch_afr == 0 % according every ch
        if isempty(find(epo_afr(i,:,:)>criterion)) & isempty(find(epo_afr(i,:,:)<-criterion))
            index = [index,i];
        end
    end    
    if len_ch_afr > 0 % according assigned ch
        tmp_ch_afr = ones(1,len_ch_afr); % 1 mean the ch exeed criterion
        for j = 1:len_ch_afr
            if isempty(find(epo_afr(i,:,ch_afr(j))>criterion)) & isempty(find(epo_afr(i,:,ch_afr(j))<-criterion))
                tmp_ch_afr(j) = 0;
            end
        end
        if isempty(find(tmp_ch_afr==1))
            index = [index,i];
        end
    end
end

%keep trials according the index
y = mf_epo_keeptrial(epo,index);

[m,n,o] = size(y);
fprintf('output %d trials\n',m);
fprintf(fid_w,'output %d trials\n',m);
fclose(fid_w);
