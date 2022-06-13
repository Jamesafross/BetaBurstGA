function [coh_chpair,coh,faxis] = mf_eegcoh(eeg,ch_group,fs)
%
% mf_eegcoh		return coherences of ch pairs according the input electrodes. 
% Usage -- [coh,faxis] = mf_eegcoh(eeg,ch_group,fs)
% Input
%	ch_group -- You can designate which electrodes are analyzed. ch_group is a vector. for example, 
%		for a 64 ch data, if you want calulate coherences of	all ch paies of the 64 ch, then 
%		ch_group is [1:64]. Sure, u can select any sub-groups. For example, if you do not want analyze
%		eog (ch 31 and 32), you can input [1:30,33:64].
% see also mf_eegcoh_2ch

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Xu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

if nargin~=3
    disp('mf_eegcoh requires 3 arguments!');
    return;
end

ch_num = length(ch_group);
%chpair_num = factorial(ch_num) / ( factorial(2)*factorial(ch_num-2) ); 
%	this would cause not accurate for double precision numbers only have about 15 digits. 
%	factorial(n)=prod(1:n). So, chpair_num = ch_num*(ch_num-1)/2
chpair_num = ch_num*(ch_num-1)/2;
coh_chpair = zeros(chpair_num,2);
coh = [];
 

k = 1; % 
for i=1:ch_num-1
	for j=i+1:ch_num
		fprintf('%d,%d\n',i,j);
		coh_chpair(k,1) = ch_group(i);
		coh_chpair(k,2) = ch_group(j);
		[tmp,faxis] = mf_eegcoh_2ch(eeg,ch_group(i),ch_group(j),fs);
		coh = [coh;tmp];
		k=k+1;
	end
end


