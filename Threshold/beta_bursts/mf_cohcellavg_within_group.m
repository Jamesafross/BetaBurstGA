function cohavg = mf_cohcellavg_within_group(cohcell,ch_group)
% mf_cohcellavg_between_group	Load a cohcell file. Then do average across ch-pairs 
%	between chs in the input ch groups.	
% see also mf_eegcoh_2ch, mf_eegcoh, mf_eeg_within_group

if nargin~=2
    disp('mf_eegcoh_within_group requires 2 arguments!');
    return;
end

cohavg = [];

ch_num = length(ch_group);
for i=1:ch_num-1
	for j=i+1:ch_num
		sn_chpair = findpair(cohcell,ch_group(i),ch_group(j));
		cohavg = [cohavg;cohcell{sn_chpair,3}];
	end
end

cohavg = mean(cohavg,1);
%chpair_num = ch_num*(ch_num-1)/2;
%cohavg = cohavg / chpair_num;


function sn_chpair = findpair(cohcell,ch1,ch2)
% return the sequence number of ch-pair of ch1 and ch2 in the cohcell

[m,n] = size(cohcell);

for i=1:m
	if cohcell{i,1}==ch1 & cohcell{i,2}==ch2
		sn_chpair = i;
		break;
	end
end
