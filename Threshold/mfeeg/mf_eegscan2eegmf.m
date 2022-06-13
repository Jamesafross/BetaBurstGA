function eeg_mf = mf_eegscan2eegmf(eeg_scan,trial_num,trial_len,ch_num)
% mf_eegeeg 	convert a eeg file of neuroscan 4.3 to a eeg file of mf_eeg.
%   only do epoch using scan, or else can't remove wrong trials.
% Usage
%	eeg_mf = mf_eegscan2eegmf(eeg_scan,trial_num,trial_len,ch_num)
% Input
%	eeg_scan -- a dat file converted from eeg file of neuroscan.
%		*.eeg is eeg file of neuroscan,before been transfered to 
%		mf_eegeeg which need to be converted to *.dat using scan.
%       !note,eeg_scan is a filename(a string),for instance,the name
%       of the data file are eeg_scan.dat,you should type
%       eeg_mf = mf_eegscan2eegmf('eeg_scan.dat');
%		convert parameters are:
% Output
%	eeg_mf -- a mat file.it is a 3-D matrix,1d-trial;2d-sample point
%		3d-electrode.

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify
% Welcome to find bugs,propose improvements, and discuss with author
%
% wu xiang     http://mail.ustc.edu.cn/~rwfwu/mfeeg/mfeeg.html
%              rwfwu@ustc.edu or rwfwu@yahoo.com.cn    
%-------------------------------------------------------------------------

if nargin~=4
    disp('mf_eegscan2eegmf requires 4 input arguments!')
	return
end

fid_r = fopen(eeg_scan,'r');

eeg_mf = zeros(trial_num,trial_len,ch_num);

ch = 1;
trial = 1;
while ~feof(fid_r)
    line = fgets(fid_r);
    line = str2num(line);
    eeg_mf(trial,:,ch) = line;
    ch = ch + 1;
    if ch == ch_num + 1
        ch = 1;
        trial = trial + 1;
    end
end
 
fclose(fid_r);
