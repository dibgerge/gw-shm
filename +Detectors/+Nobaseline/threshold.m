function thresh = threshold(Pf, sigma2)
%GETTHRESHOLD computes the threshold for a detector of sine wave with unknown phase and
% amplitude
% Inputs: 
% - Pf: probability of false alarm
% - sigma2: noise variance
% Outputs: 
% - threshold: Duh

thresh = -sigma2*log(Pf);


end

