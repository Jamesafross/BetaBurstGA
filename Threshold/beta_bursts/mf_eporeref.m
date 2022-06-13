function y = mf_eporeref(epo,ref_chs,bad_chs)
%mf_eporeref	rereference.
% Input
% ref_chs. one or more chs as ref chs. If input is 0, average reference (subtract the average over all electrodes from each electrode for each time point)
% bad_chs -- chs not included in average reference. Usually eog chs, e.g., [31,32] for neuroscan, [65,66] for biosemi.
%Usage
%   y = mf_eporeref(epo,ref_chs,bad_chs)
%Output
%   epo

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Wu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

if nargin~=3
    disp('mf_epoavg requires 3 input arguments!')
	return
end

[m,n,o] = size(epo);
if ref_chs==0
    good_chs = 1:o;
    good_chs = mf_find_vector_exclude(good_chs,bad_chs);
else
    good_chs = ref_chs;
end

%init erp
y = zeros(m,n,o);

%product erp
for i=1:m
    tmp=epo(i,:,good_chs);
    tmp=mean(tmp,3);
    for j=1:o
        y(i,:,j) = epo(i,:,j)-tmp;
    end
end





