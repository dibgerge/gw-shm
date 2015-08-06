function y = genAveragedNoise(r, sb, sigma2, sigmain, f0, dt, Nav)
%GENAVERAGEDNOISE Summary of this function goes here
%   Detailed explanation goes here
Ntaps = length(sigmain);
y = zeros(length(sb),Ntaps);

for i=1:Nav
    y = y + Detectors.addwgn(r, sigma2) + ...
        Detectors.Tapped.generateInterference(sb, sigmain, f0, dt);    
end

y = y/Nav;

end

