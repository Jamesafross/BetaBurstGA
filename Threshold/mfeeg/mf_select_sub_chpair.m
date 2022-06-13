function sub_chpair_index = mf_select_sub_chpair(chpair,ch_group,ch_group2)

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Xu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

if nargin<2 | nargin>3
    disp('mf_eegave requires 2 or 3 input arguments!')
	return
end

sub_chpair_index = [];

[chpair_num,t] = size(chpair);

for i=1:chpair_num
	if nargin == 2
		if find(ch_group==chpair(i,1)) & find(ch_group==chpair(i,2))
			sub_chpair_index = [sub_chpair_index,i];
		end
	end

	if nargin == 3
		if find(ch_group==chpair(i,1)) & find(ch_group2==chpair(i,2))
			sub_chpair_index = [sub_chpair_index,i];
		end
		if find(ch_group==chpair(i,2)) & find(ch_group2==chpair(i,1))
			sub_chpair_index = [sub_chpair_index,i];
		end
	end
end

