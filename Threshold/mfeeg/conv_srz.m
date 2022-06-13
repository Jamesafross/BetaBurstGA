function y = conv_srz(a, b)
% conv_srz convolve two vetors. same effect as matlab conv, but fast.
% Convolution and polynomial multiplication using fft.
%   Convolves vectors a and b. The resulting vector is length
%   LENGTH(A)+LENGTH(B)-1.%   If a and b are vectors of polynomial
%   coefficients, convolving them is equivalent to multiplying the 
%   two polynomials.
%
% Usage y = conv_srz(a, b)
% Input
%	two vectors
% Output
%	convoluted vector
%
% this file is written by sun rongzhe of Peking university.

len=length(a)+length(b)-1;  % 
len_pow2=pow2(nextpow2(len));    % Find smallest power of 2 that is > len

y = ifft( (fft(a, len_pow2).*fft(b, len_pow2)),len_pow2 );

y=y(1:len);               % Take just the first N elements
