function Pd  = mc_sim(s, sb, sigma2, sigma_c2, threshold, f0, Nmc, ncores)
%MC_SIM Summary of this function goes here
%   Detailed explanation goes here
import Detectors.*
import SPlib.*

if nargin == 5
    ncores = 1;
end


% Needed to be like this to make the parallel loop faster
y = s.y;
yb = sb.y;
Fs = sb.Fs;

ndet = 0;
if ncores > 1    
    if isempty(gcp('nocreate'))
        pool = parpool(ncores);
    else
        pool = gcp('nocreate');
    end 
    
    parfor i=1:Nmc
        yi = y + Withbaseline.addnoise(yb, Fs,  sigma2, sigma_c2, f0);
        A = Withbaseline.amplitude(yi, yb, Fs, f0);
        if A > threshold
            ndet = ndet + 1;
        end
    end 
else
    for i=1:Nmc
        yi = y + Withbaseline.addnoise(yb, Fs,  sigma2, sigma_c2, f0);
        A = Withbaseline.amplitude(yi, yb, Fs, f0);
        if A > threshold
            ndet = ndet + 1;
        end
    end 
end

Pd = ndet/Nmc;

end

