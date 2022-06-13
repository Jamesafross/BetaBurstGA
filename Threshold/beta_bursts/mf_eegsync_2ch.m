function plv = mf_eegsync_2ch(eeg,ch1,ch2,ncw,freq,fs)
% mf_eegsync_2ch	calculate synchronization between two electrodes.
%   the returned synchronization is not of one frequency,but of a frequency
%       band.
% Usage
%   plv = mf_eegsync_2ch(eeg,ch1,ch2,ncw,freq,fs)
% Input
%   ncw,freq,fs -- see mf_eegtf.
% Output 
%	plv -- phase locking value between two ch across trials.
%		(plf is the phase loking of one ch across trials)

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Xu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

if nargin~=6
    disp('mf_eegsync_2ch requires 6 arguments!');
    return;
end

[m,n,o] = size(eeg);

samp_period = 1/fs;
freq_num = length(freq);

plv = zeros(freq_num,n);

for i = 1:m
    coef1 = mf_tfcm( eeg(i,:,ch1),ncw,freq,fs,'coef' );
	coef2 = mf_tfcm( eeg(i,:,ch2),ncw,freq,fs,'coef' );

	%purely complex part of ch1
	cp1 = coef1;
	zero = find( abs(cp1)==0 );
	cp1(zero) = 1;
	cp1 = cp1./abs(cp1);
	cp1(zero) = 0;

	%purely complex part of ch2 
	cp2 = coef2;
	zero = find( abs(cp2)==0 );
	cp2(zero) = 1;
	cp2 = cp2./abs(cp2);
	cp2(zero) = 0;

	%purely complex part of (angle of ch1 - angle of ch2)
	zero = find( abs(cp2)==0 );
	cp2(zero) = 1;
	tmp_plv = cp1./cp2; %angle 1 - angle 2
	tmp_plv(zero) = 0;

	plv = plv + tmp_plv;					
end

plv = abs(plv/m);

