function [plv,ercoh] = mf_eegsync_within_group(eeg,ch_group,ncw,freq,fs,sync_ercoh_both)

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Xu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

if nargin~=6
    disp('mf_eegsync_within_group requires 6 arguments!');
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

ch_num = length(ch_group);
for i=1:ch_num-1
	for j=i+1:ch_num
		[plv_tmp,ercoh_tmp] = mf_eegsync(eeg,ch_group(i),ch_group(j),ncw,freq,fs,sync_ercoh_both);
		plv = plv + plv_tmp;
		ercoh = ercoh + ercoh_tmp;
	end
end

chpair_num = factorial(ch_num) / ( factorial(2)*factorial(ch_num-2) );
plv = plv / chpair_num;
ercoh = ercoh / chpair_num;
