function y = mf_epoch(raw,ecd,event_code,point_before,point_after)
%mf_epoch     cut epochs from raw data according to event codes.
%Usage
%   y = mf_epoch(raw,ecd,event_code,point_before,point_after)
%Inupt
%  raw -- raw data
%  ecd -- event code file
%  event_code -- digit or vector. if vector, codes in vector are pool together. 
%  point_before & after -- sample point before (using positive value) & after event code. 
%	The length of epoch is point_before+1+point_after. 
%Output
%  y -- returned epochs (epo).

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Wu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

if nargin~=5
    disp('mf_epoch requires 5 input arguments!')
	return
end  

%get electrode number
[ttt,trode_num] = size(raw); %include HEOG VEOG
 
[row_ecd,col_ev2] = size(ecd);

%init y
code_num = length(event_code);%nember of event code type

trialnum = 0;%number of trials of event_codes
for i=1:code_num
    tmp = length( find(ecd(:,1)==event_code(i)) );
    trialnum = trialnum + tmp;
end

len_trial = point_after + point_before+1;

y = zeros(trialnum,len_trial,trode_num);
 
%product y
trial = 1;
for i=1:row_ecd
    if ~isempty( find(event_code==ecd(i,1)) )
        tmp = raw( ecd(i,2)-point_before:ecd(i,2)+point_after,: );
        for j=1:trode_num
            y(trial,:,j) = tmp(:,j)';
        end
        trial = trial+1;
    end
end


