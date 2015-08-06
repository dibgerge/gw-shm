function Pd  = mc_sim(r, rb, Fs, sigma2, sigma_c2, threshold, f0, Nmc, ncores)
%MC_SIM Summary of this function goes here
%   Detailed explanation goes here
import Detectors.*
import SPlib.*

if nargin == 9
    ncores = 1;
end

ndet = 0;
if ncores > 1    
    if isempty(gcp('nocreate'))
        pool = parpool(ncores);
    else
        pool = gcp('nocreate');
    end 
    
    parfor i=1:Nmc
        yi = r + Tapped.addnoise(rb, Fs,  sigma2, sigma_c2, f0);
        A = Tapped.amplitude(yi, rb, Fs, f0, sigma2, sigma_c2);
        if A > threshold
            ndet = ndet + 1;
        end
    end 
else
    for i=1:Nmc
        yi = r + Tapped.addnoise(rb, Fs,  sigma2, sigma_c2, f0);
        A = Tapped.amplitude(yi, rb, Fs, f0, sigma2, sigma_c2);
        if A > threshold
            ndet = ndet + 1;
        end
    end 
end

Pd = ndet/Nmc;

end

