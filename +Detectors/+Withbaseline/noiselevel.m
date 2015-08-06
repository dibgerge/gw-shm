function [sigma2, sigma_c2] = noiselevel(A, SNR, INR)
%GETNOISELEVEL Returns noise variance given the SNR and signal amplitude
%   Detailed explanation goes here

sigma2 = 2*A/(10^(SNR/10));     
sigma_c2 = sigma2 * 10^(INR/10);

end

