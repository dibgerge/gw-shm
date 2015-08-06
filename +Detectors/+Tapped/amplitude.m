function A = amplitude(r, rb, Fs, f0, sigma2, sigma_c2)
%GETAMPLITUDE Summary of this function goes here
%  - sigmai2: A vector with length of number of taps

Ataps = Detectors.Tapped.taps_amplitude(r, rb, Fs, f0);
[N, ~] = size(r);

fact = 1./(sigma2 + N*sigma_c2);
fact = fact(:);
A = Ataps'*fact(:);

end

