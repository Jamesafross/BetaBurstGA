function  mf_erp2spm(erp_cell,SPM_erp_template,output_dir,output_filename,bad_chs)
% mf_erp2spm    import erp data into spm format 
%Usage
%   mf_mat2spm(erp_cell,SPM_erp_template_mat,output_dir,output_filename,bad_chs)
%Inupts
%   erp_cell -- erps in mfeeg format of conditions are arranged in a cell. The length of the cell is the number of conditions.
%   SPM_erp_template -- 
%       1. convert any raw EEG data which has the same setup as the erp data to be analyzed.
%       2. epoch:  All to be compared conditions should be in one file, see SPM manual, (regardless original or difference ERP waveforms).
%       3. average.
%       4. SPM file have a mat and a dat file, use the mat file as input.
%       5. Note, input includes full path in string format. e.g., 'path\name'
%       see 2condition_batch.mat, a sample spm8 batch that produce a template with 2 conditions from a Neuroscan cnt file.
%   output_dir, output_filename -- string. output_dir ends with \. 
%   bad_chs -- [] for none.
% outputs
%   SPM format erp file with the input erp data. !!saved in current working directory, so change working directory to where you want to save the file.
%   Note, 1. check the converted erp with original erp. 2. mark bad electrodes manually before source analyses. see spm manual.

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
    disp(' mf_erp2spm requires 5 arguments!');
    return;
end

D = spm_eeg_load(SPM_erp_template);

Dnew = clone(D, [output_dir,output_filename,'_' fnamedat(D)], [D.nchannels D.nsamples D.nconditions]);
for ii=1:length(erp_cell)
    Dnew(:,:,ii)=erp_cell{ii};
end

% why do not work?
% if ~isempty(bad_chs)
%     badchannels(Dnew,bad_chs,1);
% end

save(Dnew);
