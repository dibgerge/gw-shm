clear import
import Detectors.*

% --- Initialize the simulation parameters --- %
ncores = 4;
f0 = 200e3;
ntaps = 4;              % number of detector taps
tbin = 20e-6;           % time of bin in seconds
asnr = -10:5:40;
Pf = 1e-1;
Nmc = 2e3*ones(length(Pf),1);
inr = -10*ones(ntaps,1);

% --- Initialize output variables --- %
pd_sim = zeros(length(asnr), length(Pf), length(ntaps));
pf_sim = zeros(length(asnr), length(Pf), length(ntaps));
pd_theo = zeros(length(asnr), length(Pf), length(ntaps));

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
    for j=1:length(asnr)
        for k=1:length(ntaps)
            % --- segment the signals according to given time bin size --- %
            rb = SPlib.segment(sb, [28e-6, tbin], ntaps);
            r = SPlib.segment(s, [28e-6, tbin] , ntaps); 
            A = Tapped.taps_amplitude(r, rb, Fs, f0);      % get the defect amplitudes            
            [sigma2, sigma_c2] = Tapped.noiselevel(A, asnr(j), inr);
            snr = 10*log10(2*A/sigma2);
            threshold = Tapped.threshold(Pf, ntaps);            
            
            pd_sim(j,i,k) = Tapped.mc_sim(r, rb, Fs, sigma2, sigma_c2, threshold, ...
                f0, Nmc(i), ncores);
            pf_sim(j,i,k) = Tapped.mc_sim(rb, rb, Fs, sigma2, sigma_c2, threshold, ...
                f0, Nmc(i), ncores);
            [pd_theo(j,i,k), avsnr, ~]  = Tapped.getPerformance(Pf(i), snr, inr, sb.N);
              
            display(['SNR = ' num2str(asnr(j)) ', '...
                     'ntaps = ' num2str(ntaps(k)) ', '...                     
                     'PF theo = ' num2str(Pf(i)) ', ' ...
                     'PF sim = ' num2str(pf_sim(j,i,k)) ', ' ...                     
                     'PD sim = ' num2str(pd_sim(j,i,k)) ', '...                     
                     'PD theo = ' num2str(pd_theo(j,i,k))]);
        end
    end
end
toc

% --- Save output variables ---%
tapped.ntaps = ntaps;
tapped.pf_sim = pf_sim;
tapped.pd_sim = pd_sim;
tapped.pf_theo = Pf;
%tapped.pd_theo = pd_theo;
tapped.asnr = asnr;
tapped.inr = inr;
tapped.tbin = tbin;
%save tapped_data tapped

%% Plot the snr versus detection curve
hold on, plot(asnr, pd_sim(:,1,1), asnr, pd_theo(:,1,1));

