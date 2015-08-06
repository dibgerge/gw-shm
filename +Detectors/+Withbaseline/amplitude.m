function A = amplitude(y, yb, Fs, f0)
%GETAMPLITUDE Returns the signal amplitude 
%   Inputs: 
%   - y: the signal (without noise)
%   - yb: baseline signal
%   - f0: the center frequency

[f, Y] = SPlib.findfft(y-yb, Fs, [], 'shift');
[~, ind] = min(abs(f - f0));
A = abs(Y(ind)).^2/length(Y);
end

