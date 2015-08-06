function A = taps_amplitude(r, rb, Fs, f0)
%GETAMPLITUDE Returns the signal amplitude 
%   Inputs: 
%   - r: the segmented signal (without noise), where # of columns
%        corresponds to the # of taps
%   - rb: baseline signal
%   - Fs: sampling frequency
%   - f0: the center frequency

[f, Y] = SPlib.findfft(r - rb, Fs, [], 'shift');
[~, ind] = min(abs(f - f0));
A = abs(Y(ind,:)).^2/length(Y);
A = A(:);

end

