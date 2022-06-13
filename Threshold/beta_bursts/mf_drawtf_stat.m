function y = mf_drawtf_stat(tf,ch_position,ch_label,time,freq,clim,is_scale)
% mf_drawtf		draw time-frequency results    
% Usage
%   y = mf_drawtf(tf,ch_position,ch_label,time,freq,clim,is_scale)
% Input
%	tf -- tf data
%	ch_position, ch_label -- for 64 and 32 chs. ch64_pos_2D, ch64_label; ch32_pos_2D, ch32_label.
%	time & freq -- time and frequency to display
%	clim -- range of data value, shown as color,[clow chigh]
% 	is_scale -- 1: one scale for all chs use a value (lim). 0: each scale for each ch, automaticly.
% Output
%	No actuall meaning.
% See image script for how to use mf_drawtf.

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
    disp('mf_drawtf_stat requires 7 arguments!');
    return;
end

colormap(jet(256));
[m,n,o] = size(tf);
for i=1:o
    subplot( 'position',[ch_position(i,1),ch_position(i,2)-0.1,0.045,0.035] );
	if is_scale 
  		imagesc(time, freq, tf(:,:,i), clim);
	else
		tf_tmp = tf(:,:,i);
		
		most_tmp = max(max(abs(tf_tmp(:))));		
		clim_tmp = [-most_tmp,most_tmp];
		if most_tmp ==0
			clim_tmp = [-1, 1];
        end
		
  		imagesc(time, freq, tf(:,:,i),clim_tmp);
	end
    axis('xy');

   title(int2str(i)); % plot number
	title(ch_label{i}); % plot label
	title( strcat( strcat(ch_label{i},'-'),int2str(i) ) ); % plot label
end

axcopy;
