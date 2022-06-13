function vector_norm = mf_vector_norm(vector,base,norm_method)
% Usage
%   vector_norm = mf_vector_norm(vector,base,norm_method)
% Input
%	base -- same as mf_eegrmb
% norm_method 1 x - mean(base) 
%			  2 (x - mean(base)) / std(base) 					
%			  3 (x - mean(base)) / mean(base) * 100		% that's ERS/ERD
%			  4 x / mean(base) * 100		% as fMRI analysis in my lab

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
    disp('mf_vector_norm requires 3 arguments!');
    return;
end

MEAN = mean( vector(base) );
STD = std( vector(base) );

if norm_method == 1
  vector_norm = vector-MEAN;
end
if norm_method == 2
  vector_norm = (vector-MEAN)/STD;
end
if norm_method == 3
  vector_norm = (vector-MEAN)/MEAN*100;
end
if norm_method == 4
  vector_norm = vector/MEAN*100;
end

