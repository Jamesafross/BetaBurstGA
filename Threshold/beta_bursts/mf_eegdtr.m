function y = mf_eegdtr(eeg)
%Usage
%   y = mf_eegdtr(eeg)

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Xu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

if nargin~=1
    disp('mf_eegdtr requires 1 arguments!');
    return;
end
[m,n,o] = size(eeg);
y = zeros(m,n,o);

for i=1:o
	for j=1:m
		y(j,:,i) = detrend(eeg(j,:,i));
	end
end


