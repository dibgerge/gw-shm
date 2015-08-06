function sout = resample(s, Fs)
%RESAMPLE Changes the sampling rate of a signal
%   Inputs: 
%   - s: Signal objec6t
%   - Fs: new sampling rate

N = floor(Fs*s.N/s.Fs);

t2 = s.starttime + (0:N-1)'/Fs;
y = interp1(s.t, s.y, t2, 'spline');
sout = SPlib.Signal(t2, y);

end

