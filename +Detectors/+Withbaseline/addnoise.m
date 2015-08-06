function yout = addnoise(yb, Fs, sigma2, sigma_c2, f0)
%GENERATEINTERFERENCE Summary of this function goes here
%   Detailed explanation goes here

amp = sqrt(sigma_c2/2)*randn(2,1);
Ac = amp(1) + sqrt(-1)*amp(2);
delay = angle(Ac)/(2*pi*f0);
A = abs(Ac);
ndelay = round(delay*Fs);
yout = circshift(yb, ndelay);
Y = fft(yout);
Y = (Y/max(abs(Y)))*A*length(yb);
yout = ifft(Y) + sqrt(sigma2)*randn(size(Y));


end

