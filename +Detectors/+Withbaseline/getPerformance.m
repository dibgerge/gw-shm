function [Pd, lambda] = getPerformance(Pf, SNR, INR, N)
%GETPERFORMANCE evaluates the probability of detection for a given
%probability of false alarm
% Inputs: 
% - Pf: probability of false alarm. Could be scalar or vector
% - SNR: signal to noise ratio in dB. Should be a scalar.
% - INR: interference to noise ratio in dB
% - N: total number of samples

snr = 10^(SNR/10);
inr = 10^(INR/10); 

lambda = snr/(1 + N*inr);
Pd = 1-ncx2cdf(2*log(1./Pf), 2, lambda);

end

