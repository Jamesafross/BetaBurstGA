function y = mf_drawerp_stat(erp,ch_position,ch_label,time,lim,is_scale)
% mf_drawerp    draw erp results.
% Usage
%	y = mf_drawerp_stat(cell_erp,ch_position,ch_label,time,lim,is_scale)
% Input
% 	erp -- t values in erp dat format.
%	ch_position, ch_label -- for 64 and 32 chs. ch64_pos_2D, ch64_label; ch32_pos_2D, ch32_label.
%	time -- time to display
%	lim -- range of time and data value to display [left time, right time, up value, bottom value]
%	is_scale --  1: one scale for all chs use a value (lim). 0: each scale for each ch, automaticly. 
% Output
%	No actuall meaning.
% y axis of the out images have no meaning.
% See image script for how to use mf_drawerp.

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Wu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com     
%-------------------------------------------------------------------------

if nargin~=6
    disp('mf_drawerp_stat requires 6 arguments!');
    return;
end

[m,n] = size(erp);

for i=1:m
    subplot( 'position',[ch_position(i,1),ch_position(i,2)-0.1,0.045,0.035] );
	
    tt1=erp(i,:);tt2=zeros(2,n);tt2(1,:)=tt1;tt2(2,:)=tt1;freq_tmp =[1,2];
    if is_scale
        imagesc(time,freq_tmp,tt2,lim);
    else
%         most_tmp=max(max(tt2));
%         imagesc(time,freq_tmp,tt2,[-most_tmp,most_tmp]);
        imagesc(time,freq_tmp,tt2);
    end
    axis('xy');

    tmp = int2str(i);
    tmp = strcat('-',tmp);
    tmp = strcat(ch_label{i},tmp);
    title(tmp);
	
end

axcopy;
y = 0;
