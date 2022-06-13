function [tfboth,tfpl,tfnplone,tfnpltwo,plf] = mf_epotf(epo,ncw_init,freq,fs,is_vary_ncw,ncw_step,E_type,is_two)
% mf_epotf get all kind of time-frequency representations, input is epoch file.
% Usage
%   [tfboth,tfpl,tfnplone,tfnpltwo,plf] = mf_epotf(epo,ncw_init,freq,fs,is_vary_ncw,ncw_step,E_type,is_two)
% Input
%	epo -- epoch file
%	ncw_init,freq,fs,is_vary_ncw,ncw_step,E_type -- see mf_tfcm & mf_cmorlet.
%	is_two -- whether calculate tfnpltwo. 1 or 0. if 0, returned tfnpltwo = 0.
%   E_type -- returned energy type.one of the following
%       'amplitude': abs(coef)
%       'power': abs(coef).^2
%       'db':10*log10(abs(coef).^2)
% Output
%   tf -- a 3 dimension matrix, dim 1 is frequency, dim 2 is sample point, 
%       dim 3 is electrode.    
%       tfpl -- phase-locked.
%       tfnpl -- non-phase-locked,that's,induced.for controversy about how
%           get this activity, we use two type of method.the result are
%           tfnplone and tfnpltwo,which are same.
%       tfboth -- include tfpl and tfnpl.
%       plf -- phase-locking-factor. Ref: Tallon-Baudry et al 
% see also mf_tfcm,mf_cmorlet

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Wu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

if nargin~=8
    disp('mf_epotf requires 8 arguments!');
    return;
end

switch E_type 
    case 'coef'
        disp('Coef is not for average on trials. Please use "power" or "amplitude"');
        return;
    case 'db'
        disp('Warning. If coef is between -1 ~ 1, "db" will be negative.');
        disp('tfnplone is calculated by tfnplboth - tfpl, which is equal to tfnpltwo for "power" or "amplitude", so no need to calculate tfnpltwo.');
        disp('But for "db", calculate and use tfnpltwo rather than tfnplone');
end

[m,n,o] = size(epo);
erp = mf_epoavg(epo);

%%% tfpl: phase-locked.time-freqency on erp
disp('pl');
tfpl = zeros(length(freq),n,o);
for i=1:o
    tfpl(:,:,i) = mf_tfcm( erp(i,:),ncw_init,freq,fs,is_vary_ncw,ncw_step,E_type );
end

%%% tfboth: include tfpl and tfnpl.time-frequency on single trial and
%       average.which can also be get by tfpl+tfnpltwo.
%%% plf: phase-locking-factor
disp('both & plf');
tfboth = zeros(length(freq),n,o);
plf = zeros(length(freq),n,o);

fprintf('ch: ');
for i=1:o
    fprintf('%d ',i);
    if mod(i,16) == 0 
        fprintf('\n');
    end
    
    temp_tf = zeros(length(freq),n);
    temp_plf = zeros(length(freq),n);
    for j=1:m
        coef = mf_tfcm( epo(j,:,i),ncw_init,freq,fs,is_vary_ncw,ncw_step,'coef' );
        % tfboth
        switch E_type 
            case 'coef'
                temp_tf = temp_tf + coef;
            case 'amplitude'
                temp_tf = temp_tf + abs(coef);
            case 'power'
                temp_tf = temp_tf + abs(coef).^2;
            case 'db'
                temp_tf = temp_tf + 10*log10( abs(coef).^2 );
        end
        % plf
        zero = find( abs(coef)==0 );
        coef(zero) = 1;
        coef = coef./abs(coef);
        coef(zero) = 0;
        temp_plf = temp_plf + coef;
    end
    tfboth(:,:,i) = temp_tf/m;
    plf(:,:,i) = abs(temp_plf/m);
end
%fprintf('\n');

%%% tfnplone: non-phase-locked. get by tfboth - tfpl
disp('nplone');
tfnplone = tfboth - tfpl;

%%% tfnpltwo: non-phase-locked. get by: 
%   1 single trial - erp
%   2 time-frequency
%   3 average
if is_two == 1
	disp('npltwo');
	
	eponoerp = zeros(m,n,o);
	for i = 1:o
	    for j = 1:m
	        eponoerp(j,:,i) = epo(j,:,i) - erp(i,:);
	    end
	end

	tfnpltwo = zeros(length(freq),n,o);

	fprintf('ch: ');
	for i=1:o
	    fprintf('%d ',i);
	    if mod(i,16) == 0 
	        fprintf('\n');
	    end
     
	    temp = zeros(length(freq),n);
	    for j=1:m
	        temp = mf_tfcm( eponoerp(j,:,i),ncw_init,freq,fs,is_vary_ncw,ncw_step,E_type ) + temp;
	    end
	    tfnpltwo(:,:,i) = temp/m;
	end
	fprintf('\n');
end

if is_two == 0
	tfnpltwo = 0;
end
