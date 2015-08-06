clear import
import Detectors.*

% --- Initialize the simulation parameters --- %
ncores = 4;
f0 = 200e3;
ntaps = 4;              % number of detector taps
tbin = 20e-6;           % time of bin in seconds
asnr = -10;
Pf = 0.01:0.01:0.1;
Nmc = 2e3*ones(length(Pf),1);
inr = -10*ones(ntaps,1);
Nav = [4, 8, 16];

% --- Initialize output variables --- %
pd_sim = zeros(length(Pf), length(Nav));
pf_sim = zeros(length(Pf), length(Nav));

% --- Load the guided wave signal --- %
sim = importdata('Data/complex-plate.txt'); 
s  = SPlib.Signal(sim(:,1), sim(:,5)*1e9);
sb = SPlib.Signal(sim(:,1), sim(:,2)*1e9);
s  = SPlib.resample(s, sb.Fs/20);
sb = SPlib.resample(sb, sb.Fs/20);
s  = SPlib.truncate(s, [], 150e-6);
sb = SPlib.truncate(sb, [], 150e-6);
Fs = sb.Fs;

% --- Start the simulation --- %
tic
for i=1:length(Pf)
    for j=1:length(Nav)
        % --- segment the signals according to given time bin size --- %
        rb = SPlib.segment(sb, [28e-6, tbin], ntaps);
        r = SPlib.segment(s, [28e-6, tbin] , ntaps); 
        A = Tapped.taps_amplitude(r, rb, Fs, f0);      % get the defect amplitudes            
        [sigma2, sigma_c2] = Tapped.noiselevel(A, asnr(j), inr);
        snr = 10*log10(2*A/sigma2);
        threshold = Tapped.threshold(Pf, ntaps);            

        pd_sim(i,j) = Tapped.mc_sim_averaging(r, rb, Fs, sigma2, sigma_c2, threshold, ...
            f0, Nmc(i), Nav(j), ncores);
        pf_sim(i,j) = Tapped.mc_sim_averaging(rb, rb, Fs, sigma2, sigma_c2, threshold, ...
            f0, Nmc(i), Nav(j), ncores);

        display(['Nav = ' num2str(Nav(j)) ', '...
                 'ntaps = ' num2str(ntaps) ', '...                     
                 'PF sim = ' num2str(pf_sim(i,j)) ', ' ...                     
                 'PD sim = ' num2str(pd_sim(i,j))])
    end
end
toc


%% Plot the snr versus detection curve
hold on, plot(asnr, pd_sim(:,1,1), asnr, pd_theo(:,1,1));

