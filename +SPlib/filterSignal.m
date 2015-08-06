function yout = filterSignal(y, Fs, cutoff, type)

if nargin < 4 
    type = 'lowpass';
end

[f, Y] = SPlib.findfft(y, Fs);
Y = SPlib.filterFrequencies(f, Y, cutoff, type);
yout = ifft(Y);

end

