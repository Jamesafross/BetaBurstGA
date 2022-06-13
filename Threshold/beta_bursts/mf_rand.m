function y = mf_rand(M,min,max)
% mf_rand   convert the return of rand to integers and 
%           in a limite[min,max].
% Usage
%   y = mf_rand(M,min,max)
% Input
%   M -- scalar,vector,or matrix,same as the input of rand

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Xu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

if nargin~=3
    disp('mf_rand requires 3 arguments!');
    return;
end

y = floor( rand(M)*(max-min+1)+min );
