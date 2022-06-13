function [plv,ercoh] = mf_eegsync_between_group(eeg,ch_group1,ch_group2,ncw,freq,fs,sync_ercoh_both)

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Xu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

if nargin~=7
    disp('mf_eegsync_between_group requires 7 arguments!');
    return;
end

[m,n,o] = size(eeg);

freq_num = length(freq);
if sync_ercoh_both==1 | sync_ercoh_both==3
	plv = zeros(freq_num,n);
end
if sync_ercoh_both==2 | sync_ercoh_both==3
	ercoh = zeros(freq_num,n);
end

ch_num1 = length(ch_group1);
ch_num2 = length(ch_group2);

for i=1:ch_num1
	for j=1:ch_num2
		[plv_tmp,ercoh_tmp] = mf_eegsync(eeg,ch_group1(i),ch_group2(j),ncw,freq,fs,sync_ercoh_both);
		plv = plv + plv_tmp;
		ercoh = ercoh + ercoh_tmp;		
	end
end

chpair_num = ch_num1 * ch_num2;
plv = plv / chpair_num;
ercoh = ercoh / chpair_num;
