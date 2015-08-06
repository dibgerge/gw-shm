function [sigma2, sigma_c2] = noiselevel(A, ASNR, INR)
%GETINTERFERENCELEVEL Summary of this function goes here
%   Detailed explanation goes here
sigma2 = 2*mean(A)/(10^(ASNR/10));
sigma_c2 = (sigma2 * 10.^(INR/10));
end

