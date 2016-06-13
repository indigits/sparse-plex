% This script plots the results from 
% bench_phase_transition_snr_signals.m 
% please run that script before running this one.

clear all; close all; clc; 
% Create the directory for storing images
[status_code,message,message_id] = mkdir('bin');

export = true;

data_k8 = load('bin/phase_transition_K=8.mat');

mf = spx.graphics.Figures();

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


mf.new_figure('F1-score SNR vs Signals per subspace at theta=10');
theta  = 10;
theta_index = find (thetas == theta,  1);
% snrs, ngs
fmeasures = average_fmeasures(theta_index, :, :);
fmeasures = reshape(fmeasures, nsnrs, nng);
imagesc(ng_values, SNRs, fmeasures);
set(gca,'YDir','normal');
ylabel('SNR (dB)');
xlabel('Signals per subspace');
colormap gray;
colorbar;

if export
set(gcf, 'units', 'inches', 'position', [.8 .8 4 3]);
set(gca,'FontSize',8);
set(findall(gcf,'type','text'),'FontSize',8);
export_fig bin/phase_transition_K=8_theta=10.png -r120 -nocrop;
export_fig bin/phase_transition_K=8_theta=10.pdf;
end



mf.new_figure('F1-score SNR vs Signals per subspace at theta=20');
theta  = 20;
theta_index = find (thetas == theta,  1);
% snrs, ngs
fmeasures = average_fmeasures(theta_index, :, :);
fmeasures = reshape(fmeasures, nsnrs, nng);
imagesc(ng_values, SNRs, fmeasures);
set(gca,'YDir','normal');
ylabel('SNR (dB)');
xlabel('Signals per subspace');
colormap gray;
colorbar;

if export
set(gcf, 'units', 'inches', 'position', [1 1 4 3]);
set(gca,'FontSize',8);
set(findall(gcf,'type','text'),'FontSize',8);
export_fig bin/phase_transition_K=8_theta=20.png -r120 -nocrop;
export_fig bin/phase_transition_K=8_theta=20.pdf;
end






mf.new_figure('F1-score SNR vs Signals per subspace at theta=30');
theta  = 30;
theta_index = find (thetas == theta,  1);
% snrs, ngs
fmeasures = average_fmeasures(theta_index, :, :);
fmeasures = reshape(fmeasures, nsnrs, nng);
imagesc(ng_values, SNRs, fmeasures);
set(gca,'YDir','normal');
ylabel('SNR (dB)');
xlabel('Signals per subspace');
colormap gray;
colorbar;



if export
set(gcf, 'units', 'inches', 'position', [1.2 1.2 4 3]);
set(gca,'FontSize',8);
set(findall(gcf,'type','text'),'FontSize',8);
export_fig bin/phase_transition_K=8_theta=30.png -r120 -nocrop;
export_fig bin/phase_transition_K=8_theta=30.pdf;
end

