function [sync_chpair,sync] = mf_eegsync(eeg,ch_group,ncw,freq,fs)
%
% mf_eegsync		return synchronization of ch pairs according the input electrodes. 
% Usage -- [sync_chpair,sync] = mf_eegsync(eeg,ch_group,ncw,freq,fs)
% Input
%	ch_group -- You can designate which electrodes are analyzed. ch_group is a vector. for example, 
%		for a 64 ch data, if you want calulate synchronization of	all ch paies of the 64 ch, then 
%		ch_group is [1:64]. Sure, u can select any sub-groups. For example, if you do not want analyze
%		eog (ch 31 and 32), you can input [1:30,33:64].
% Storage and output
%	Synchronization is stored in two matrix. Matrix 1 is 2D, pair number * 2. For each ch pair(row),
%	column 1 is the number of the first ch of the pair, and column 2 is the number of the second ch of the pair.
%	Matrix 2 is the actrual synchronization values, which is arranged according to matrix 1. Matrix is 3D, row is 
%	frequency, column is time point, and 3th D is pair.
% see also mf_eegsync_2ch

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Xu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

if nargin~=5
    disp('mf_eegsync requires 5 arguments!');
    return;
end

[m,n,o] = size(eeg);

ch_num = length(ch_group);
%chpair_num = factorial(ch_num) / ( factorial(2)*factorial(ch_num-2) ); 
%	this would cause not accurate for double precision numbers only have about 15 digits. 
%	factorial(n)=prod(1:n). So, chpair_num = ch_num*(ch_num-1)/2
chpair_num = ch_num*(ch_num-1)/2;
sync_chpair = zeros(chpair_num,2);
sync = zeros(m,n,chpair_num); 

k = 1; % 
for i=1:ch_num-1
	for j=i+1:ch_num
		fprintf('%d,%d\n',i,j);
		sync_chpair(k,1) = ch_group(i);
		sync_chpair(k,2) = ch_group(j);
		sync(:,:,k) = mf_eegsync_2ch(eeg,ch_group(i),ch_group(j),ncw,freq,fs);
		k=k+1;
	end
end



