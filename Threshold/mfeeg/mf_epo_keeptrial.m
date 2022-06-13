function y = mf_epo_keeptrial(epo,index_right)
% mf_keeptrial   used in mf_epoafr, to keep right trials in epo.
% Usage
%   y = mf_epo_keeptrial(epo,index_right)
% Input
%	epo -- epoch file
%   index_right -- a vector,include trial numbers of right trials.
%       for example, 10 trials, trial 1,3,5,6,8,9 are right,trial 
%       2,4,7,10 are wrong,then index_right should be [1,3,5,6,8,9].

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Wu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

if nargin~=2
    disp('mf_keeptrial requires 2 input arguments!')
    return
end

[m,n,o] = size(epo);
y = zeros( length(index_right),n,o );

for i=1:length(index_right)
        y(i,:,:) = epo(index_right(i),:,:);
end


