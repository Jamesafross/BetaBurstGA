function [specpl_norm,specboth_norm,specpl_raw,specboth_raw] = mf_epospec(epo)
% Usage: [specpl_norm,specboth_norm,specpl_raw,specboth_raw] = mf_epospec(epo)
% get modulus spectra of epo data using fft.
% input

% Output
%   normalized (Nozaradan et al. 2012) and raw modulus spectra, of pl and both types (see mf_epotf)

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Xu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

if (nargin ~= 1)
    disp('mf_epospec requires 1 input arguments!')
	return
end

[m,n,o] = size(epo);
erp = mf_epoavg(epo);
y=zeros(o,n);

% pl_raw
disp('pl');
specpl_raw = zeros(o,n);
for ii=1:o
    coef = fft(erp(ii,:))/n;
%    specpl_raw(ii,:) = 2*abs(coef);
    specpl_raw(ii,:) = 2*10*log10(abs(coef));
end

% both_raw
disp('both');
specboth_raw = zeros(o,n);
for ii=1:o
    tmp_spec = zeros(1,n);
    for jj=1:m
        tmp_sig = epo(jj,:,ii);tmp_sig = tmp_sig(:)';
        coef = fft(tmp_sig)/n;
        %    tmp_spec = tmp_spec + 2*abs(coef);
        tmp_spec = tmp_spec + 2*10*log10(abs(coef));
    end
    specboth_raw(ii,:) = tmp_spec/m;
end

% normalization 
specpl_norm = zeros(o,n);
specboth_norm = zeros(o,n);
adjcent_step = 3; adjcent_freq_num = 2;
for ii=1:o
    for jj=1:n
        if jj>(adjcent_step+adjcent_freq_num-1) & jj<(n-(adjcent_step+adjcent_freq_num-1))
            specpl_norm(ii,jj) = specpl_raw(ii,jj) - ( specpl_raw(ii,jj-adjcent_step)+specpl_raw(ii,jj-adjcent_step-1)+...
                specpl_raw(ii,jj+adjcent_step)+specpl_raw(ii,jj+adjcent_step+1) )/4;
            specboth_norm(ii,jj) = specboth_raw(ii,jj) - ( specboth_raw(ii,jj-adjcent_step)+specboth_raw(ii,jj-adjcent_step-1)+...
                specboth_raw(ii,jj+adjcent_step)+specboth_raw(ii,jj+adjcent_step+1) )/4;
        end
    end
end
for ii=1:o
    for jj=1:n
        if jj<=(adjcent_step+adjcent_freq_num-1) | jj>=(n-(adjcent_step+adjcent_freq_num-1))
            specpl_norm(ii,jj)=0;
            specboth_norm(ii,jj)=0;
        end
    end
end







