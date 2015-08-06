function threshold = threshold(Pf, ntaps)
%GETTHRESHOLD computes the threshold for a detector of sine wave with unknown phase and
% amplitude
% Inputs: 
% - Pf: probability of false alarm
% - ntaps: number of taps used 

threshold = chi2inv(1-Pf, ntaps*2)/2;


end

