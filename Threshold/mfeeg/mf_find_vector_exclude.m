function y = mf_find_vector_exclude(vect1,vect2)
%mf_find_vector_exclude	function as find(vect1!=vect2).
% used for exclude bad chs
%Usage
%   y = mf_find_vector_exclude(vect1,vect2)


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
    disp('mf_find_vector_exclude requires 2 input arguments!')
	return
end

y=[];

for ii=1:length(vect1)
    if isempty(find(vect2==vect1(ii)))
        y=[y vect1(ii)];
    end
end





