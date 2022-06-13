function y = mf_sync_draw(sync_chpair,sync_pval,ch_pos,pval)
% mf_coh_draw	draw the significant ch pairs on the scalp. also for sync.
%	modify from mf_topo2D.m. for simplification, some parameters in mf_topo2d.m 
%	is taken as constant value. if need (i.e. for 32 ch), you can modify them in files.

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Xu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

%------------------mf_topo2D------------------------------
% just modify a little in constant value part

%%%%% constant value
load ch64_label; % this label can be used for 32 ch. if 128, no label
%load ch64_label_noeog; % use this if you excled eog in ch_display
%ch_plot = [1:30,33:64];
%ch_display = [1:30,33:64];
%Values = zeros(1,64);
ch_plot = [1:30];
ch_display = [1:30];
Values = zeros(1,32);
is_display_ch = 1;
surface_most = [];
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
if isempty(surface_most);
	surface_most = max(max(abs(Zi)));
end
caxis( [-surface_most,surface_most] );
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

if is_display_ch ==1 
	plot(x_display,y_display,'.','Color',[0 0 0],'markersize',8);
	
	for i = 1:length(x_display)
		text(x_display(i)+0.01,y_display(i),...
			ch64_label{i},...												
			'HorizontalAlignment','left',...
			'VerticalAlignment','middle','Color', [0 0 0], ...
			'FontSize',8, 'buttondownfcn', ...
           	['tmpstr = get(gco, ''userdata'');'...
            'set(gco, ''userdata'', get(gco, ''string''));' ...
           	'set(gco, ''string'', tmpstr); clear tmpstr;'] );
	end
	
end
%			num2str(ch_display(i)),...										% plot ch number
%			ch64_label{i},...													% plot ch label
%			strcat( strcat(ch64_label{i},'-'),num2str(ch_display(i)) ),...	% plot ch label and number

%%%%%

%----------------------------end mf_topo2D------------------------------------------



%---------------------------added part---------------------------------------------
c_ch = [29,27,22,23,25,17,18,9,11,12,5,7];
pair_num = length(sync_pval);
for i=1:pair_num
	hold on;

%!!!x,y, or x_display,y_display are ch[1:30,33:64], but the ch number information are
%	not stored in them. the program just know row 1:32. 
%	while sync_pval include the ch number information, so need according modification to
%	make them congruent.
	ch1 = sync_chpair(i,1);
	if ch1>30
		ch1 = ch1 - 2; % for example, ch 1 according to row 1 in x,y. while
	end				   % ch 33 according to row 31 in x,y.	
	ch2 = sync_chpair(i,2);
	if ch2>30
		ch2 = ch2 - 2;
	end
% for p value

if find(c_ch==sync_chpair(i,1)) & find(c_ch==sync_chpair(i,2)) % only draw ch pair defined by c_ch
	if sync_pval(i)<=pval & sync_pval(i)>=0
		mf_line2pt( [ x_display(ch1)+0.01,y_display(ch1) ],...
		[ x_display(ch2)+0.01,y_display(ch2) ],...
		0.0001,'r' );
	end
	if sync_pval(i)>=-pval & sync_pval(i)<0 
		mf_line2pt( [ x_display(ch1)+0.01,y_display(ch1) ],...
		[ x_display(ch2)+0.01,y_display(ch2) ],...
		0.0001,'b' );
	end
end
%}
%{
% for percent or number
	if sync_pval(i)>=pval
		mf_line2pt( [ x_display(ch1)+0.01,y_display(ch1) ],...
		[ x_display(ch2)+0.01,y_display(ch2) ],...
		0.0001,'r' );
	end
	if sync_pval(i)<=-pval 
		mf_line2pt( [ x_display(ch1)+0.01,y_display(ch1) ],...
		[ x_display(ch2)+0.01,y_display(ch2) ],...
		0.0001,'b' );
	end
%}
end
%-----------------------end added part-------------------------------------------

axis square
axis off
set(gcf, 'color', [1,1,1]); % background 
hold off
%colorbar;
colormap(white);

