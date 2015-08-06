clear import
import Detectors.*

% --- Initialize the simulation parameters --- %
ncores = 4;
f0 = 200e3;
snr = -20:5:30;
Pf = 1e-2;
Nmc = 1e4*ones(length(Pf),1);

% --- Initialize output variables --- %
pd_sim = zeros(length(snr), length(Pf));
pf_sim = zeros(length(snr), length(Pf));
pd_theo = zeros(length(snr), length(Pf));

% --- Load the guided wave signal --- %
sim = importdata('Data/simple-plate-no-baseline.txt');
Ts = sim(2,1) - sim(1,1);
s = SPlib.Signal(Ts, sim(:,5)*1e9);
sb = SPlib.Signal(Ts, sim(:,2)*1e9);
s = SPlib.window(s, 48e-6, []);
sb = SPlib.window(sb, 48e-6, []);
s = SPlib.resample(s, s.Fs/10);
sb = SPlib.resample(sb, sb.Fs/10);

% --- Start the simulaiton --- %
tic
for i=1:length(Pf)
    for j=1:length(snr)     
        pd_sim(j,i) = Nobaseline.mc_sim(s, Pf(i), snr(j), f0, Nmc(i), ncores);        
        pf_sim(j,i) = Nobaseline.mc_sim(sb, Pf(i), snr(j), f0, Nmc(i), ncores);
        pd_theo(j,i) = Nobaseline.getPerformance(Pf(i), snr(j));

       display(['SNR = ' num2str(snr(j)) ', ' ...
                'PF theo = ' num2str(Pf(i)) ', ' ...
                'PF sim = ', num2str(pf_sim(j,i)) ', ' ...
                'PD sim = ' num2str(pd_sim(j,i)) ', ' ...
                'PD theo = ' num2str(pd_theo(j,i))]);
    end
end
toc

% --- Save output variables ---%
nobaseline.Nmc = Nmc;
nobaseline.pf_theo = Pf;
nobaseline.pf_sim = pf_sim;
nobaseline.snr = snr;
nobaseline.pd_theo = pd_theo;
nobaseline.pd_sim = pd_sim;
% save nobaseline_data nobaseline


%% Plot the SNR with PD
figure('units', 'normalized', 'position', [0,0,1,1])
plot(snr, pd_theo, snr, pd_sim);

