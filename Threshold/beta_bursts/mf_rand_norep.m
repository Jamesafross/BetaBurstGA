function y = mf_rand_norep(M,min,max,is_continue)
% mf_randvect   same as mf_rand,but no repeat elements
%       !!!note: (max-min+1)>= total elements number of y
% Usage
%   y = mf_rand_norep(M,min,max,is_continue)
% Input
%   is_continue -- whether adjacent elements are continue ie.. 34 or 43 
% see also mf_rand

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Xu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com    
%-------------------------------------------------------------------------

if nargin~=4
    disp('mf_rand_norep requires 4 arguments!');
    return;
end

y = zeros(M);

element_num = 1;
dim = length(M);
for i = 1:dim
    element_num = element_num*M(i);
end

for i = 1:element_num
    if i == 1
        y(i) = mf_rand(1,min,max);
    else
        while(1)
            y(i) = mf_rand(1,min,max);
            if is_continue
                if  isempty( find( y(1:i-1)==y(i) ) );
                    break;
                end
            else
                if isempty( find( y(1:i-1)==y(i) ) ) & isempty( find( [-1,1]==y(i)-y(i-1) ) )
                    break;
                end
            end
        end
    end
end
