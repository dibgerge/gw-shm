%% --- Theoretical SNR vs PD: No baseline detector --

import Detectors.*
pf = [1e-3, 1e-2, 1e-1];
snr = -10:1:20;
pd = zeros(length(snr), length(pf));

for i=1:length(snr)
    pd(i,:) = Nobaseline.getPerformance(pf, snr(i));
end
figure('Position', get(0,'Screensize'));
plot(snr, pd, 'LineWidth', 1.5)
set(gca, 'Box', 'on', ...
    'FontSize', 36, 'FontWeight', 'normal', 'FontName', 'Serif', ...
    'XTick', -20:5:25, 'YTick', 0:0.1:1)
xlabel('SNR (dB)')
ylabel('P_D')
grid on
annotation('textarrow', [0.5, 0.582], [0.675, 0.675], ...
        'String', 'P_F = 10^{-1}', ...
        'LineWidth', 0.5, 'Color', 'k', 'FontSize', 28, 'FontName', 'Serif')
    
annotation('textarrow', [0.5, 0.64], [0.585, 0.585], ...
        'String', 'P_F = 10^{-2}', ...
        'LineWidth', 0.5, 'Color', 'k', 'FontSize', 28, 'FontName', 'Serif')

annotation('textarrow', [0.5, 0.67], [0.505, 0.505], ...
        'String', 'P_F = 10^{-3}', ...
        'LineWidth', 0.5, 'Color', 'k', 'FontSize', 28, 'FontName', 'Serif')
    
matlab2tikz('no_baseline_theoretical_snr_plot.tikz', 'height', '\figureheight', ...
    'width', '\figurewidth');
%    'extraCode', 'y label style={at={(axis description cs:0.1,.5)},rotate=0,anchor=south}')


%% --- Theoretical SNR vs PD: baseline detector --
import Detectors.*

pf = 1e-2;
INR = [-Inf, -30, -20, -10];
snr = -10:1:50;
pd = zeros(length(snr), length(INR));

for i=1:length(INR)
    for j=1:length(snr)
        pd(j,i) = Withbaseline.getPerformance(pf, snr(j), INR(i), 1e4);
    end
end
figure('Position', get(0,'Screensize'));
plot(snr, pd, 'LineWidth', 1.5)
set(gca, 'Box', 'on', ...
    'FontSize', 36, 'FontWeight', 'normal', 'FontName', 'Serif', ...
    'XTick', -10:5:50, 'YTick', 0:0.1:1)
xlabel('SNR (dB)')
ylabel('P_D', 'Position', [-13, 0.5])

annotation('textarrow', [0.35, 0.394], [0.675, 0.675], ...
        'String', 'INR = -\infty dB', ...
        'LineWidth', 0.5, 'Color', 'k', 'FontSize', 26, 'FontName', 'Serif')
    
annotation('textarrow', [0.35, 0.52], [0.605, 0.605], ...
        'String', 'INR = -30 dB', ...
        'LineWidth', 0.5, 'Color', 'k', 'FontSize', 26, 'FontName', 'Serif')

annotation('textarrow', [0.35, 0.635], [0.535, 0.535], ...
        'String', 'INR = -20 dB', ...
        'LineWidth', 0.5, 'Color', 'k', 'FontSize', 26, 'FontName', 'Serif')
    
annotation('textarrow', [0.35, 0.755], [0.465, 0.465], ...
        'String', 'INR = -10 dB', ...
        'LineWidth', 0.5, 'Color', 'k', 'FontSize', 26, 'FontName', 'Serif')    

matlab2tikz('simple_baseline_theoretical_snr_plot.tikz', ...
      'height', '\figureheight', 'width', '\figurewidth')

 
%% -- Theoretical SNR vs PD: Tapped detector --
import Detectors.*

pf = 1e-2;
INR = -10;
A = -10:1:50;
taps = 2.^(0:2:6);
pd = zeros(length(A), length(taps));
asnr = zeros(length(A), length(taps));
ainr = zeros(length(A), length(taps));

for i=1:length(taps)
    for j=1:length(A)
        %snr = (A(j) - (0:(taps(i)-1)))';
        snr = A(j);
        %inr = (INR  - 2*(0:(taps(i)-1)))';        
        [pd(j,i), asnr(j,i), ainr(j,i)] = Tapped.getPerformance(pf, snr, INR*ones(taps(i),1), 1e3);
    end
end

figure('Position', get(0,'Screensize'));
plot(asnr, pd, 'LineWidth', 1.5)
% 
set(gca, 'Box', 'on', ...
    'FontSize', 36, 'FontWeight', 'normal', 'FontName', 'Serif', ...
     'YTick', 0:0.1:1)
xlabel('ASNR (dB)')
ylabel('P_D', 'Position', [-13, 0.5])
grid on 
annotation('textarrow', [0.35, 0.42], [0.675, 0.675], ...
        'String', '64 taps', ...
        'LineWidth', 0.5, 'Color', 'k', 'FontSize', 26, 'FontName', 'Serif')
    
annotation('textarrow', [0.35, 0.49], [0.605, 0.605], ...
        'String', '16 taps', ...
        'LineWidth', 0.5, 'Color', 'k', 'FontSize', 26, 'FontName', 'Serif')

annotation('textarrow', [0.35, 0.555], [0.535, 0.535], ...
        'String', '4 taps', ...
        'LineWidth', 0.5, 'Color', 'k', 'FontSize', 26, 'FontName', 'Serif')
    
annotation('textarrow', [0.35, 0.625], [0.465, 0.465], ...
        'String', '1 tap', ...
        'LineWidth', 0.5, 'Color', 'k', 'FontSize', 26, 'FontName', 'Serif')    

matlab2tikz('tapped_theoretical_snr_plot.tikz', ...
    'height', '\figureheight', 'width', '\figurewidth')


%% --- Time domain signal: No baseline -- 
pth = 'Data/';

d = load([pth 'simple-plate-no-baseline.txt']);
t = d(1:5:end,1);
sig = d(1:5:end,15);

figure('Position', get(0,'Screensize'));
plot(t*1e6, sig*1e9, 'LineWidth', 1.5)
set(gca, 'MinorGridLineStyle', 'none', 'XGrid', 'off', 'YGrid', 'off', 'ZGrid', 'off', ...
    'Box', 'on', ...
    'FontSize', 36, 'FontWeight', 'normal', 'FontName', 'Serif')
axis tight

xlabel('Time (\mu s)')
ylabel('Displacement (nm)')

matlab2tikz('simple_structure_no_baseline_signal.tikz', ...
      'height', '\figureheight', 'width', '\figurewidth')
 
 %% --- Time domain signal: Baseline signal -- 
pth = 'Data/';

d = load([pth 'simple-plate-baselined-Y71000.txt']);
t = d(1:5:end,1);
sig = d(1:5:end,15);
% sig = d(1:5:end,15)-d(1:5:end,2);

figure('Position', get(0,'Screensize'));
plot(t*1e6, sig*1e9, 'LineWidth', 1.5)
set(gca, 'MinorGridLineStyle', 'none', 'XGrid', 'off', 'YGrid', 'off', 'ZGrid', 'off', ...
    'Box', 'on', ...
    'FontSize', 36, 'FontWeight', 'normal', 'FontName', 'Serif')
axis tight

xlabel('Time (\mu s)')
ylabel('Displacement (nm)')

matlab2tikz('simple_structure_baseline_signal.tikz', ...
     'height', '\figureheight', 'width', '\figurewidth')
 
  %% --- Time domain signal: Complex signal -- 
pth = 'Data/';

d = load([pth 'complex-plate.txt']);
t = d(:,1);
ind1 = find(t>400e-6, 1);
t = t(1:5:ind1);
sig = d(1:5:ind1,8);
% sig = d(1:5:ind1,8)-d(1:5:ind1,2);

figure('Position', get(0,'Screensize'));
plot(t*1e6, sig*1e9, 'LineWidth', 1.5)
set(gca, 'MinorGridLineStyle', 'none', 'XGrid', 'off', 'YGrid', 'off', 'ZGrid', 'off', ...
    'Box', 'on', ...
    'FontSize', 36, 'FontWeight', 'normal', 'FontName', 'Serif')
axis tight

xlabel('Time (\mu s)')
ylabel('Displacement (nm)')

matlab2tikz('complex_structure_baseline_signal.tikz', ...
    'height', '\figureheight', 'width', '\figurewidth')

%% --- Monte-carlo ROC: NO-Baseline detector
pth = 'Data/';
load([pth 'nobaseline_data']);


figure('Position', get(0,'Screensize'));
h1 = semilogx(nobaseline.pf_theo, nobaseline.pd_theo', '-.b',  'LineWidth', 1.5);
hold on;
h2 = semilogx(nobaseline.pf_sim', nobaseline.pd_sim', 'ob', 'MarkerFaceColor', 'b', 'MarkerSize', 4);

set(gca, 'Box', 'on', 'FontSize', 36, 'FontWeight', 'normal', 'FontName', 'Serif')
axis tight
xlabel('P_F')
ylabel('P_D')
legend([h1(1), h2(1)],'Theoretical', 'Simulation', 'Location', 'NorthWest')


annotation('textarrow', [0.48, 0.53], [0.75, 0.75], ...
        'String', 'SNR = 10 dB', ...
        'LineWidth', 0.5, 'Color', 'k', 'FontSize', 26, 'FontName', 'Serif')
    
annotation('textarrow', [0.48, 0.72], [0.4, 0.4], ...
        'String', 'SNR = 0 dB', ...
        'LineWidth', 0.5, 'Color', 'k', 'FontSize', 26, 'FontName', 'Serif')

annotation('textarrow', [0.48, 0.73], [0.3, 0.3], ...
        'String', 'SNR = -10 dB', ...
        'LineWidth', 0.5, 'Color', 'k', 'FontSize', 26, 'FontName', 'Serif')
    
matlab2tikz('roc_nobaseline.tikz', 'height', '\figureheight', 'width', '\figurewidth')    

%% --- Monte-carlo ROC: Baseline detector
pth = 'Data/';
load([pth 'baseline_data']);


figure('Position', get(0,'Screensize'));
h1 = semilogx(baseline.pf_theo, baseline.pd_theo', '-.b',  'LineWidth', 1.5);
hold on;
h2 = semilogx(baseline.pf_sim', baseline.pd_sim', 'ob', 'MarkerFaceColor', 'b', 'MarkerSize', 4);

set(gca, 'Box', 'on', 'FontSize', 36, 'FontWeight', 'normal', 'FontName', 'Serif', 'YTick', 0:0.1:1)
axis tight
xlabel('P_F')
ylabel('P_D')
legend([h1(1), h2(1)],'Theoretical', 'Simulation', 'Location', 'NorthWest')


annotation('textarrow', [0.48, 0.53], [0.75, 0.75], ...
        'String', 'INR = -\infty dB', ...
        'LineWidth', 0.5, 'Color', 'k', 'FontSize', 26, 'FontName', 'Serif')
    
annotation('textarrow', [0.48, 0.64], [0.4, 0.4], ...
        'String', 'INR = -30 dB', ...
        'LineWidth', 0.5, 'Color', 'k', 'FontSize', 26, 'FontName', 'Serif')

annotation('textarrow', [0.48, 0.72], [0.3, 0.3], ...
        'String', 'INR = -10 dB', ...
        'LineWidth', 0.5, 'Color', 'k', 'FontSize', 26, 'FontName', 'Serif')
    
matlab2tikz('roc_baseline.tikz', 'height', '\figureheight', 'width', '\figurewidth')    

%% --- Monte-carlo ROC: tapped detector
pth = 'Data/';
load([pth 'tapped_data']);


figure('Position', get(0,'Screensize'));
h1 = semilogx(tapped.pf_theo, tapped.pd_theo, '-.b',  'LineWidth', 1.5);
hold on;
h2 = semilogx(tapped.pf_sim, tapped.pd_sim, 'ob', 'MarkerFaceColor', 'b', ...
    'MarkerSize', 3, 'LineWidth', 1);

% shading interp
% set(h, 'FaceVertexAlphaData ', 0.1)

set(gca, 'Box', 'on', 'FontSize', 36, 'FontWeight', 'normal', 'FontName', 'Serif', 'YTick', 0:0.1:1)
axis tight
xlabel('P_F')
ylabel('P_D')
legend([h1(1), h2(1)],'Theoretical', 'Simulation', 'Location', 'SouthEast')


annotation('textarrow', [0.35, 0.35], [0.75, 0.84], ...
        'String', '8 taps', ...
        'LineWidth', 0.5, 'Color', 'k', 'FontSize', 26, 'FontName', 'Serif')
    
annotation('textarrow', [0.55, 0.55], [0.63, 0.77], ...
        'String', '4 taps', ...
        'LineWidth', 0.5, 'Color', 'k', 'FontSize', 26, 'FontName', 'Serif')

annotation('textarrow', [0.77, 0.77], [0.53, 0.72], ...
        'String', '1 tap', ...
        'LineWidth', 0.5, 'Color', 'k', 'FontSize', 26, 'FontName', 'Serif')
    
matlab2tikz('roc_tapped.tikz', 'height', '\figureheight', 'width', '\figurewidth')   


%% --- Averaging performance
pth = 'Data/';
load([pth 'averaging_tapped_data']);


figure('Position', get(0,'Screensize'));
h2 = semilogx(averaging.pf_sim, averaging.pd_sim, '-o', ...
    'MarkerFaceColor', 'b', 'MarkerSize', 4,  'LineWidth', 1.5);

% shading interp
% set(h, 'FaceVertexAlphaData ', 0.1)

set(gca, 'Box', 'on', 'FontSize', 36, 'FontWeight', 'normal', 'FontName', ...
    'Serif', 'YTick', 0:0.1:1)
axis tight
grid on
xlabel('P_F')
ylabel('P_D')
%legend( h2(1),'Theoretical', 'Simulation', 'Location', 'NorthWest')


annotation('textarrow', [0.48, 0.48], [0.88, 0.91], ...
        'String', '16 averages', ...
        'LineWidth', 0.5, 'Color', 'k', 'FontSize', 26, 'FontName', 'Serif')
    
annotation('textarrow', [0.42, 0.47], [0.5, 0.5], ...
        'String', '4 averages', ...
        'LineWidth', 0.5, 'Color', 'k', 'FontSize', 26, 'FontName', 'Serif')

annotation('textarrow', [0.58, 0.63], [0.3, 0.3], ...
        'String', 'No averaging', ...
        'LineWidth', 0.5, 'Color', 'k', 'FontSize', 26, 'FontName', 'Serif')
    
matlab2tikz('roc_averaging.tikz', 'height', '\figureheight', 'width', '\figurewidth')   
