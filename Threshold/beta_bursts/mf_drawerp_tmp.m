function y = mf_drawerp(cell_erp,ch_position,ch_label,time,lim,is_scale,color_order)
% mf_drawerp    draw erp results.
% Usage
%	y = mf_drawerp(cell_erp,ch_position,ch_label,time,lim,is_scale,color_order)
% Input
% 	cell_erp -- cell_erp is a row cell, every element in it is a erp, its length is the number of erps.
%				the size of erps should be equal,even only one erp, should be put into a cell.
%				now the largest number of erp is 6, if want more,modify source file. 
%   color_order -- erps are colored in the order. default is red-blue-yellow-green-magenta-cyan,
%               copy [1 0 0;0 0 1;0.85 0.85 0;0 0.5 0;0.75 0 0.75;0 0.75 0.75] as input. You can also change it as need.
%	ch_position, ch_label -- for 64 and 32 chs. ch64_pos_2D, ch64_label; ch32_pos_2D, ch32_label.
%	time -- time to display
%	lim -- range of time and data value to display [left time, right time, up value, bottom value]
%	is_scale --  1: one scale for all chs use a value (lim). 0: each scale for each ch, automaticly. 
% Output
%	No actuall meaning.
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

if nargin~=7
    disp('mf_drawerp requires 7 arguments!');
    return;
end

set(gcf,'DefaultAxesColorOrder',color_order);

num_erp = length(cell_erp);

erp1 = cell_erp{1};
[m,n] = size(erp1);

if num_erp >= 2 
	erp2 = cell_erp{2}; 
end 
if num_erp >= 3
	erp3 = cell_erp{3}; 
end
if num_erp >= 4
	erp4 = cell_erp{4}; 
end
if num_erp >= 5
	erp5 = cell_erp{5}; 
end
if num_erp >= 6
	erp6 = cell_erp{6}; 
end

for i=1:m
    subplot( 'position',[ch_position(i,1),ch_position(i,2)-0.1,0.045,0.035] );

	if num_erp==1		
    	plot( time,erp1(i,:),'LineWidth',2);
	end
	if num_erp==2		
    	plot( time,erp1(i,:),time,erp2(i,:),'LineWidth',2);
	end
	if num_erp==3	
    	plot( time,erp1(i,:),time,erp2(i,:),time,erp3(i,:),'LineWidth',2);
	end
	if num_erp==4		
    	plot( time,erp1(i,:),time,erp2(i,:),time,erp3(i,:),time,erp4(i,:),'LineWidth',2);
	end
	if num_erp==5		
    	plot( time,erp1(i,:),time,erp2(i,:),time,erp3(i,:),time,erp4(i,:),time,erp5(i,:),'LineWidth',2);
	end	
	if num_erp==6		
    	plot( time,erp1(i,:),time,erp2(i,:),time,erp3(i,:),time,erp4(i,:),time,erp5(i,:),time,erp6(i,:),'LineWidth',2);
	end	

    tmp = int2str(i);
    tmp = strcat('--',tmp);
    tmp = strcat(ch_label{i},tmp);
    title(tmp);
	
	if is_scale  
		axis(lim);
	end
end

axcopy;
y = 0;
