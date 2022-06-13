function [rawdata,ecd] = mf_cnt2raw(cnt_path,cnt_filename)
% mf_cnt2raw Get rawdata and ecd file used in mfeeg from Neuroscan cnt file. Reading cnt file is by EEGLAB. 
% Usage
%   [rawdata,ecd] = mf_cnt2raw(cnt_path,cnt_filename)
% Input
%   cnt_path --  e.g., 'D:\data\' on windows. Note to
%   include the slash sign.
%   cnt_filename -- e.g., 'sbj.cnt'.
% Output
%   Outputs are stored in the current directory.
%   rawdata -- sample point * electrode
%   ecd -- event code file (ecd). column 1 is events, column 2 is sample
%   points.
% Note: The trigger is assumed to be number. If letter(s) is used as
% trigger(s), please do corresponding changes in this fuction and mf_epoch.

%-------------------------------------------------------------------------
% update history
% 7/9/2013
% Modified by Xiang Wu. 
% 7/3/2013
% Writen by Liang Zhou. 
%-------------------------------------------------------------------------

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Wu     rwfwuwx@gmail.com 
%              http://sourceforge.net/p/mfeeg                  
%-------------------------------------------------------------------------

EEG = pop_loadcnt([cnt_path cnt_filename], 'dataformat', 'int16');% EEG.data :<ch x sample points>

% rawdata
rawdata=EEG.data'; % <sample points * ch>  

% ecd
ecd = [];
for i=1:length(EEG.event)
    ecd_tmp = zeros(1,2);
    
    % type
    if isnumeric(EEG.event(i).type) % number is assumed
        ecd_tmp(1,1)= EEG.event(i).type;
    end
    
    if ischar(EEG.event(i).type)  
        if ~isempty(str2num(EEG.event(i).type)) % letter(s) is not assumed. But number may be in char format, e.g. '3'.
            ecd_tmp(1,1)= str2num(EEG.event(i).type);
        end
    end
    
    % latency
    ecd_tmp(1,2)=EEG.event(i).latency-1;  % eeglab adds 1 to original sample points, thus "-1" to keep original data
	%ecd_tmp(1,2)=EEG.event(i).latency;  % if to keep consistency with eeglab,not "-1".
    
    ecd = [ecd;ecd_tmp];
end






