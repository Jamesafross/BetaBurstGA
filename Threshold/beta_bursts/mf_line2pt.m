function mf_line2pt(pt1,pt2,step,color)
%mf_line2pt draw line between two point. No return value.
%Usage 
%	mf_line2pt(pt1,pt2,step,color) 
%	for example, to draw line between [-1,-1] and [1,1], it should be typed
%	"mf_line2pt([-1,-1],[1,1],0.01,'r')" or "mf_line2pt([-1,-1],[1,1],0.01,'r')". Note, 
%	step is always positive, do not input negative value.

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Xu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

%for a line, y=ax+b
Y = [pt1(2),pt2(2)]';
X = [pt1(1),1;pt2(1),1];
ab = X\Y; 
a=ab(1); 
b=ab(2);



if abs(a)==Inf  
	x = pt1(1); %or pt2(1)
	
	if pt1(2)>pt2(2)
		step = -step;
	end
	y = pt1(2):step:pt2(2);
else
	if pt1(1)>pt2(1)
		step = -step;
	end
	x = pt1(1):step:pt2(1);
	
	y = a*x+b; 
end

plot(x,y,color);
