function thresh = threshold(Pf, sigma2, sigma_c2, N)
%GETTHRESHOLD computes the threshold for a detector of sine wave with unknown phase and
% amplitude
% Inputs: 
% - Pf: probability of false alarm
% - sigma2: noise variance
% - sigma2i: interference variance
% - N: the number of samples
% Outputs: 
% - thresh: Duh

thresh = -(sigma2 + N*sigma_c2)*log(Pf);


end

