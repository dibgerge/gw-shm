function sigma2 = noiselevel(A, SNR)
%GETNOISELEVEL Returns the noise variance required to acheive given SNR
%   Detailed explanation 

sigma2 = 2*A/(10^(SNR/10));

end

