clear import
import Detectors.*

% --- Initialize the simulation parameters --- %
ncores = 4;
f0 = 200e3;
snr = -10:5:40;
inr = -10;
Pf = 1e-2;
Nmc = 1e4*ones(length(Pf),1);

% --- Initialize output variables --- %
pd_sim = zeros(length(snr), length(Pf), length(inr));
pf_sim = zeros(length(snr), length(Pf), length(inr));
pd_theo = zeros(length(snr), length(Pf), length(inr));

% --- Load the guided wave signal --- %
sim = importdata('Data/simple-plate-baselined-Y71000.txt');
Ts = sim(2,1) - sim(1,1);
s  = SPlib.Signal(Ts, sim(:,5)*1e9);
sb = SPlib.Signal(Ts, sim(:,2)*1e9);
s = SPlib.resample(s, s.Fs/10);
sb = SPlib.resample(sb, sb.Fs/10);
A = Withbaseline.amplitude(s.y, sb.y, s.Fs, f0);

% --- Start the simulaiton --- %
tic
for i=1:length(Pf)
    for j=1:length(snr)
        for k=1:length(inr)                   
            [sigma2, sigma_c2] = Withbaseline.noiselevel(A, snr(j), inr(k));
            threshold = Withbaseline.threshold(Pf(i), sigma2, sigma_c2, sb.N);
            
            pd_sim(j,i,k) = Withbaseline.mc_sim(s, sb, sigma2, ...
                sigma_c2, threshold, f0, Nmc(i), ncores);
            pf_sim(j,i,k) =  Withbaseline.mc_sim(sb, sb, sigma2, ...
                sigma_c2, threshold,  f0, Nmc(i), ncores);
            pd_theo(j,i,k) = Withbaseline.getPerformance(Pf(k), snr(j), inr(i), sb.N);

            display(['SNR = ' num2str(snr(j)) ', '...
                     'INR = ' num2str(inr(k)) ', '...                     
                     'PF theo = ' num2str(Pf(i)) ', ' ...
                     'PF sim = ' num2str(pf_sim(j,i,k)) ', ' ...                     
                     'PD sim = ' num2str(pd_sim(j,i,k)), ', '...
                     'PD theo = ' num2str(pd_theo(j,i,k))]);
        end
    end
end
toc

% --- Save output variables ---%
baseline.Nmc = Nmc;
baseline.pf_theo = Pf;
baseline.pf_sim = pf_sim;
baseline.snr = snr;
baseline.inr = inr;
baseline.pd_theo = pd_theo;
baseline.pd_sim = pd_sim; 
% save baseline_data baseline

%% Plot the snr versus detection curve
plot(snr, pd_sim(:,1,1), snr, pd_theo(:,1,1))
