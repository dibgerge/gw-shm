function y = addnoise(sb, Fs, sigma2, sigma_c2, f0)
%GENERATEINTERFERENCE Summary of this function goes here
%   Detailed explanation goes here

[N, ntaps] = size(sb);
Ac = sqrt(sigma_c2(:)/2).*(randn(ntaps, 1) + sqrt(-1).*randn(ntaps, 1));
delay = angle(Ac)/(2*pi*f0);
ndelay = round(delay*Fs);
A = abs(Ac);

ytemp = zeros(size(sb));
for i=1:ntaps
    ytemp(:,i) = circshift(sb(:,i), ndelay(i));
    ytemp(1:ndelay(i),i) = 0;
end

Y = fft(ytemp);
Ymx = max(abs(Y));
Y = (Y./repmat(Ymx(:)', N, 1)).*repmat(A(:)', N, 1)*N;
y = ifft(Y) + sqrt(sigma2)*randn(size(Y));
end

