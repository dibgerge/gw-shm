function Pd = getPerformance(Pf, SNR)
%GETPERFORMANCE evaluates the probability of detection for a given
%probability of false alarm
% Inputs: 
% - Pf: probability of false alarm. Could be scalar or vector
% - SNR: SNR value in dB. Should be a scalar.

lambda = 10^(SNR/10);

Pd = 1-ncx2cdf(2*log(1./Pf), 2, lambda);

end

