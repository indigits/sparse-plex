clear all; close all; clc; 

export = true;

data_k8 = load('bin/phase_transition_theta_signals_K=8.mat');

mf = SPX_Figures();

thetas = data_k8.thetas;
nt  = numel(thetas);

ng_values = data_k8.ng_values;
nng = numel(ng_values);

SNRs = data_k8.SNRs;
nsnrs = numel(SNRs);

Trials = data_k8.Trials;
average_fmeasures = data_k8.average_fmeasures;
average_precisions = data_k8.average_precisions;
average_recalls = data_k8.average_recalls;
average_clustering_ratios = data_k8.average_clustering_ratios;


mf.new_figure('F1-score Principal angle vs Signals per subspace at SNR=15 dB');
SNR  = 15;
snr_index = find (SNRs == SNR,  1);
% snrs, ngs
fmeasures = average_fmeasures(:, snr_index, :);
fmeasures = reshape(fmeasures, nt, nng);
imagesc(ng_values, thetas, fmeasures);
set(gca,'YDir','normal');
ylabel('Minimum principal angle');
xlabel('Signals per subspace');
colormap gray;
colorbar;

if export
set(gcf, 'units', 'inches', 'position', [.8 .8 4 3]);
set(gca,'FontSize',8);
set(findall(gcf,'type','text'),'FontSize',8);
export_fig bin\phase_transition_K=8_SNR=15.png -r120 -nocrop;
export_fig bin\phase_transition_K=8_SNR=15.pdf;
end



mf.new_figure('F1-score Principal angle vs Signals per subspace at SNR=25 dB');
SNR  = 25;
snr_index = find (SNRs == SNR,  1);
% snrs, ngs
fmeasures = average_fmeasures(:, snr_index, :);
fmeasures = reshape(fmeasures, nt, nng);
imagesc(ng_values, thetas, fmeasures);
set(gca,'YDir','normal');
ylabel('Minimum principal angle');
xlabel('Signals per subspace');
colormap gray;
colorbar;

if export
set(gcf, 'units', 'inches', 'position', [1 1 4 3]);
set(gca,'FontSize',8);
set(findall(gcf,'type','text'),'FontSize',8);
export_fig bin\phase_transition_K=8_SNR=25.png -r120 -nocrop;
export_fig bin\phase_transition_K=8_SNR=25.pdf;
end






mf.new_figure('F1-score Principal angle vs Signals per subspace at SNR=35 dB');
SNR  = 35;
snr_index = find (SNRs == SNR,  1);
% snrs, ngs
fmeasures = average_fmeasures(:, snr_index, :); 
fmeasures = reshape(fmeasures, nt, nng);
imagesc(ng_values, thetas, fmeasures);
set(gca,'YDir','normal');
ylabel('Minimum principal angle');
xlabel('Signals per subspace');
colormap gray;
colorbar;



if export
set(gcf, 'units', 'inches', 'position', [1.2 1.2 4 3]);
set(gca,'FontSize',8);
set(findall(gcf,'type','text'),'FontSize',8);
export_fig bin\phase_transition_K=8_SNR=35.png -r120 -nocrop;
export_fig bin\phase_transition_K=8_SNR=35.pdf;
end

