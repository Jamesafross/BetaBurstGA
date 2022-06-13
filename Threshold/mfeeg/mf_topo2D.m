function Zi = mf_topo2D(ch_pos,ch_plot,ch_display,Values,is_display_ch,surface_lim)
% mf_topo2D		plot topography in 2D.
% Usage
%	mf_topo2D(ch_pos,ch_plot,ch_display,Values,is_display_ch,,surface_lim)
% Input
% 	ch_pos -- 2D position of electrodes, whose value 
%				are between 0~1. Can be 32,64,128 or any other.
%				Data format should be n*2. Column one is x axis,column 
%				two  is y axis, n is the number of electrodes.
%	ch_plot -- The electrodes will be used to plot topo. You can select partial 
%				to plot.
%	ch_display -- see "about ch" below.
%	values -- A vector.The data will be displayed. For erp, they are mean
%				of a time band; for TF(time-frequency), they are mean of
%				a time band and a frequency band.
%				whose length is equal to the total ch number, i.e., 32,64,128.
%	is_display_ch -- 0 or 1. If 1, display all ch (include veog or not) on topo. Every ch is
%				a black point.
%	surface_lim -- range of data value to show. default, it is according to Values, in this condition, input [].
%				or you can define it, a negtive value and a positive value, e.g., [-a b].
%	about ch:	ch_pos -- all ch.
%				ch_plot -- any subset of all ch. which is used to draw the map.
%					some ch may not be used, for eog, bad ch, value too little or lage etc.
%				ch_display -- although some ch are not included when calculating map, they still 
%					need to be displayed if you display ch (as a black point, parameter is_display_ch).
%				usually, eog (31,32 for eegscan) are not included in ch_plot and ch_display. (sure, you 
%					can include them). but if eog not in ch_plot, do not include them in ch_display, 
%					because the locations of eog are seperated from other ch. 
%				Values -- values of all ch should be, then it be cut according to ch_plot. 
%	some usage example (for 64ch, eog are 31,32)
%		load ch64_pos_2D; % load a ch position
%		1 mf_topo2D(ch64_pos_2D,[1:64],[1:64],value,1,[]); 
%			% calulate all ch, and display ch on the map.
%		2 mf_topo2D(ch64_pos_2D,[1:64],[1:64],value,0,[]); 
%			% calulate all ch, not display ch. (but ch_display still needed to be input. )
%		3 mf_topo2D(ch64_pos_2D,[1:30,33:64],[1:30,33;64],value,1,[]); 
%			% exclude eog in calulating, and exclude eog in displaying ch.	
%		4 mf_topo2D(ch64_pos_2D,[1:9,11:30,33:64],[1:30,33;64],value,1,[]); 
%			% exclude ch 10 in calulating(bad ch), but still display it.
%		5 mf_topo2D(ch64_pos_2D,[1:9,11:30,33:64],[1:9,11:30,33;64],value,1,[]); 
%			% exclude ch 10 in calulating(bad ch), and not display it.
%		6 mf_topo2D(ch64_pos_2D,[1:9,11:30,33:64],[1:9,11:30,33:64],value,1,15); 
%			% input the most value 15 as the scale of map.
%		7 mf_topo2D(ch64_pos_2D,[1:30,33:64],[1:30,33;64],zeros(1,64),1,[]); 
%			%the aim is not to draw map, but to show the ch position on the head scalp.
%			%in this instance, you may want to legend the number and(or) name of the ch.
%			%you need to modify some codes in file.
%
%	This file is derived form eeglab by sunrongzhe of beijing university. 
%		I add position file of neuroscan and made some other modifies.

% Program explanation
%	1 The size of axis, head, ears, nose are according to lim
%	2 Electrode position are according to not only lim, but also sf.
%		They are not the absolute position according to head contour,
%		but reletive position so all electrode could be displayed.

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Wu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

%%%%% constant value
%load ch64_label; % this label can also be used for 32 ch. if 128, no label
%load neuroscan_ch64_label_noeog; % use this if you excled eog in ch_display

lim = 0.5; % plot topography between rect [-0.5,-0.5,0.5,0.5].
				% And the head contour is just in the rect.


%%%%%
Values = Values(ch_plot);

% x,y axis of electrodes
x = ch_pos(:,1);
x_display = x; 

x = x(ch_plot);
x_display = x_display(ch_display);

x = x - median(x); % here, 0,0 is not left-up of axis, rather center of axis.
x_display = x_display - median(x_display);

y = ch_pos(:,2);
% y = 1 - ch_pos(:,2); % do this out of mf_topo2D
y_display = y;

y = y(ch_plot);
y_display = y_display(ch_display);

y = y - median(y);
y_display = y_display - median(y_display);


%%%%% scale, for not draw ch outside head contour 
% calculate distances of electrodes from center
dis = [];
for i = 1:length(x_display)
	tmp = sqrt(x_display(i)^2+y_display(i)^2);
	dis = [dis tmp];
end

sf = lim*0.85/max(dis); % which is a scale factor, make the outmost ch in head contour,the head contour's radius is 0.5
						%	0.85 is for advide ch just on the contour
% scale x,y,x_display,y_display according to sf						
x  = x*sf;
y  = y*sf;
x_display = x_display*sf;
y_display = y_display*sf;


%%%%% prepare for plot topography
% Interpolate scalp map data and convert x,y,values to 2D matrix
xi = linspace(-lim,lim,128);
yi = linspace(-lim,lim,128);
[Xi,Yi,Zi] = griddata(x,y',Values,xi,yi','V4'); 

% Mask out data outside the head 
mask = (sqrt(Xi.^2 + Yi.^2) <= lim); % mask outside the plotting circle
Zi(find(mask == 0)) = NaN;           % mask non-plotting voxels with NaNs

% length of grid entry
delta = xi(2)-xi(1); 

% Scale the axes 
cla  % clear current axis
hold on
h = gca; % uses current axes
set(gca,'Xlim',[-lim lim]*1.2,'Ylim',[-lim lim]*1.2); % 1.2 for draw ears and nose


%%%%% Plot topography
% plot values
if isempty(surface_lim);
	surface_lim = [min(min(Zi)),max(max(Zi))];
end
caxis( surface_lim );
tmph = surface(Xi-delta/2,Yi-delta/2,zeros(size(Zi)),Zi,...
       'EdgeColor','none','FaceColor','flat');

% plot contour
[cls chs] = contour(Xi,Yi,Zi,6,'k'); 
for h=chs, set(h,'color', [0 0 0]); end % set color of the conture

	
%%%%% topography post-process
% Plot filled ring to mask jagged grid boundary around 0.5
hin  = lim*(1- 0.007/2);
rin    =  lim*(1-0.035/2);              % inner ring radius
circ = linspace(0,2*pi,201);
rx = sin(circ); 
ry = cos(circ); 
ringx = [[rx(:)' rx(1) ]*(rin+0.035)  [rx(:)' rx(1)]*rin];
ringy = [[ry(:)' ry(1) ]*(rin+0.035)  [ry(:)' ry(1)]*rin];
ringh= patch(ringx,ringy,0.01*ones(size(ringx)),[1 1 1],'edgecolor','none'); hold on

% Plot head outline 
headx = [[rx(:)' rx(1) ]*(hin+0.007)  [rx(:)' rx(1)]*hin];
heady = [[ry(:)' ry(1) ]*(hin+0.007)  [ry(:)' ry(1)]*hin];
ringh= patch(headx,heady,ones(size(headx)),[0 0 0],'edgecolor',[0 0 0]);

% Plot ears and nose 
base  = lim-.0046;
basex = 0.18*lim;                   % nose width
tip   = 1.15*lim; 
tiphw = .04*lim;                    % nose tip half width
tipr  = .01*lim;                    % nose tip rounding
q = .04;                            % ear lengthening
EarX  = [.497-.005  .510  .518  .5299 .5419  .54    .547   .532   .510   .489-.005]; 
EarY  = [q+.0555 q+.0775 q+.0783 q+.0746 q+.0555 -.0055 -.0932 -.1313 -.1384 -.1199];
plot3([basex;tiphw;0;-tiphw;-basex],[base;tip-tipr;tip;tip-tipr;base],...
     2*ones(size([basex;tiphw;0;-tiphw;-basex])),...
     'Color',[0 0 0],'LineWidth',3);                                       % plot nose
plot3(EarX,EarY,2*ones(size(EarX)),'color',[0 0 0],'LineWidth',3)    % plot left ear
plot3(-EarX,EarY,2*ones(size(EarY)),'color',[0 0 0],'LineWidth',3)   % plot right ear


%%%%% electrode position
% only display ch in ch_plot
%{
if is_display_ch ==1 
	plot(x,y,'.','Color',[0 0 0],'markersize',8);
	for i = 1:length(x)
		text(x(i)+0.01,y(i),num2str(ch_plot(i)),'HorizontalAlignment','left',...
			'VerticalAlignment','middle','Color', [0 0 0], ...
			'FontSize',8, 'buttondownfcn', ...
            ['tmpstr = get(gco, ''userdata'');'...
             'set(gco, ''userdata'', get(gco, ''string''));' ...
             'set(gco, ''string'', tmpstr); clear tmpstr;'] );
	end
end
%}

% display all ch (in ch_display, not include eog)

if is_display_ch == 1 
	plot(x_display,y_display,'.','Color',[0 0 0],'markersize',8); % why this influence color when 32 ch?
%	
% 	for i = 1:length(x_display)
% 		text(x_display(i)+0.01,y_display(i),...
% 			num2str(ch_display(i)),...		
% 			'HorizontalAlignment','left',...
% 			'VerticalAlignment','middle','Color', [0 0 0], ...
% 			'FontSize',8, 'buttondownfcn', ...
%            	['tmpstr = get(gco, ''userdata'');'...
%             'set(gco, ''userdata'', get(gco, ''string''));' ...
%            	'set(gco, ''string'', tmpstr); clear tmpstr;'] );
% 	end
%	
end
%			num2str(ch_display(i)),...										% plot ch number
%			neuroscan_ch64_label_noeog{i},...													% plot ch label
%			strcat( strcat(neuroscan_ch64_label_noeog{i},'-'),num2str(ch_display(i)) ),...	% plot ch label and number

%%%%%
axis square
axis off
set(gcf, 'color', [1,1,1]); % background 
hold off
colorbar;

