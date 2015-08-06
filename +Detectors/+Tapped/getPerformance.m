function [Pd, avg_snr, avg_inr]  = getPerformance(Pf, ASNR, INR, N)
%GETPERFORMANCE evaluates the probability of detection for a given
%probability of false alarm
% Inputs: 
% - Pf: probability of false alarm. Could be scalar or vector
% - SNR: signal to noise ratio in dB. Should be a scalar.

asnr = 10.^(ASNR/10);
inr = 10.^(INR/10); 
lambda = sum(asnr./(1 + N*inr));
ntaps = length(asnr);

Pd = 1-ncx2cdf(chi2inv(1-Pf, ntaps*2), 2*ntaps, lambda);

avg_snr = 10*log10(mean(asnr));
avg_inr = 10*log10(mean(inr));

end

