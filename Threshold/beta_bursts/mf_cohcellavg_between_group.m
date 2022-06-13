function cohavg = mf_cohcellavg_between_group(cohcell,ch_group1,ch_group2)
% mf_cohcellavg_between_group	Load a cohcell file. Then do average across ch-pairs 
%	between chs in the input two ch groups.	(not ch-pair within each or both the input two ch groups)
% see also mf_eegcoh_2ch, mf_eegcoh, mf_eeg_within_group

if nargin~=3
    disp('mf_eegcoh_between_group requires 3 arguments!');
    return;
end

cohavg = [];

ch_num1 = length(ch_group1);
ch_num2 = length(ch_group2);

for i=1:ch_num1
	for j=1:ch_num2
		sn_chpair = findpair(cohcell,ch_group1(i),ch_group2(j));
		cohavg = [cohavg;cohcell{sn_chpair,3}];
	end
end

cohavg = mean(cohavg,1);
%chpair_num = ch_num1 * ch_num2;
%cohavg = cohavg / chpair_num;



function sn_chpair = findpair(cohcell,ch1,ch2)
% return the sequence number of ch-pair of ch1 and ch1 in the cohcell

[m,n] = size(cohcell);

for i=1:m
	if cohcell{i,1}==ch1 & cohcell{i,2}==ch2
		sn_chpair = i;
		break;
	end
end

