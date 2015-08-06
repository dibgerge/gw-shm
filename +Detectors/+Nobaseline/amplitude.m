function A = amplitude(y, Fs, f0)
%GETAMPLITUDE Returns the signal amplitude 
%   Inputs: 
%   - s: Signal object, without noise
%   - f0: the center frequency

[f, Y] = SPlib.findfft(y, Fs, [], 'shift');
[~, ind] = min(abs(f - f0));
A = abs(Y(ind,:)).^2/size(Y,1);
end

