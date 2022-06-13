function [ncw,freq_width,time_width] = mf_cmorlet_character(ncw_type,freq_range,is_vary_ncw,ncw_step)
%mf_cmorlet_character   given ncws at 20 Hz and frequencies, plot ncws, frequency and time window widths. used when decide which ncw and which ncw increasing step to use before analyses.   
%Usage
%  [ncw,freq_width,time_width] = mf_cmorlet_character(ncw_type,freq_range,is_vary_ncw,ncw_step)
%Input
%   ncw_type -- one or more ncws at 20 Hz, as digit or vector. usually ncw>5.
%   freq_range -- e.g., 1:200.
%	is vary_ncw -- 0: fixed ncw for all frequencies. 1: ncws increase with frequency.
%	ncw_step -- ncws increse with the step.
%Output
%	ncw,freqency and time width of the morlet wavelet
%see also mf_cmorlet for more explanation.
%Sample usage
%	[n,f,t]=mf_cmorlet_character([6 7 9 11 13 15],[1:200],1,0.1);

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Wu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com         
%-------------------------------------------------------------------------	

if nargin~=4
    disp('mf_cmorlet_character requires 4 arguments!');
    return;
end

ncw = zeros(length(ncw_type),length(freq_range));
time_width = zeros(length(ncw_type),length(freq_range));
freq_width = zeros(length(ncw_type),length(freq_range));

% fixed ncw
if is_vary_ncw==0
	for ii=1:length(ncw_type)
		ncw(ii,:)=ncw_type(ii);
		freq_width(ii,:) = freq_range./ncw(ii,:)*2;  
		time_width(ii,:) = 2*1./(2*pi*(freq_width(ii,:)/2)); % second
	end
end

%
% varying ncw
if is_vary_ncw==1
	step=ones(1,length(ncw_type))*ncw_step;
	for ii=1:length(ncw_type)
		for jj=1:length(freq_range)
			ncw(ii,jj)=(jj-20)*step(ii)+ncw_type(ii);
			freq_width(ii,jj) = jj/ncw(ii,jj)*2;  
			time_width(ii,jj) = 2*1/(2*pi*(freq_width(ii,jj)/2)); % second
		end
	end
end

figure(1); 
subplot(2,2,1);plot(freq_range,ncw)
title('ncw');
xlabel('frequency');
ylabel('ncw value');
axis([min(freq_range),max(freq_range),min(min(ncw))-1,max(max(ncw))+1]);

subplot(2,2,2);plot(freq_range,freq_width);
title('frequency width');
xlabel('frequency');
ylabel('Hz');

subplot(2,2,3);plot(freq_range,time_width);
title('time width');
xlabel('frequency');
ylabel('second');

subplot(2,2,4);plot(freq_range(1:20),time_width(:,1:20));
title('time width');
legend_string=cell(1,length(ncw_type));
for jj=1:length(ncw_type)
	tmp=num2str(ncw_type(jj));
	legend_string{jj}=tmp;
end
legend(legend_string);
xlabel('frequency');
ylabel('second');
