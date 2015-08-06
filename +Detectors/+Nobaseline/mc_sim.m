function Pd  = mc_sim(s, Pf, snr, f0, Nmc, ncores)
%MC_SIM Summary of this function goes here
%   Detailed explanation goes here
import Detectors.*
import SPlib.*

if nargin == 5
    ncores = 1;
end

A = Nobaseline.amplitude(s.y, s.Fs, f0);   % get the amplitude of the defect 
sigma2 = Nobaseline.noiselevel(A, snr);
threshold = Nobaseline.threshold(Pf, sigma2);   

% precomputations to make parallel computing faster
Fs = s.Fs;
y0 = s.y;
sigma = sqrt(sigma2);

% Executing in batches might enhance performance. However if too high, it is bad.
speedup  = 5;
y0 = repmat(y0(:), 1, speedup);
ndet = 0;

if ncores > 1    
    if isempty(gcp('nocreate'))
        pool = parpool(ncores);
%        addAttachedFiles(pool, {'Detectors.Nobaseline.isDetected', ...
%            'Detectors.Nobaseline.getAmplitude'});
    else
        pool = gcp('nocreate');
    end 
    
    parfor i=1:ceil(Nmc/speedup)
        y = y0 + sigma*randn(size(y0));
        A = Nobaseline.amplitude(y, Fs, f0);        
        ndet = ndet + sum(A > threshold);
    end
else
    for i=1:ceil(Nmc/speedup)
        y = y0 + sigma*randn(size(y0));
        A = Nobaseline.amplitude(y, Fs, f0);        
        ndet = ndet + sum(A > threshold);
    end
end

Pd = ndet/Nmc;

end

