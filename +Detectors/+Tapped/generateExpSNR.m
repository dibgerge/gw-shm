function snr = generateExpSNR(A, alpha, ntaps)
%GENERATEEXPSNR Summary of this function goes here
%   Detailed explanation goes here

n = 0:ntaps-1;
snr = A*exp(-alpha*n);
snr = 10*log10(snr);
snr = snr(:);

end

