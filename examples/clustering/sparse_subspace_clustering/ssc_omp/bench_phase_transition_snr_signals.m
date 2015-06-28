clear all; close all; clc; rng('default');
% Create the directory for storing images
[status_code,message,message_id] = mkdir('bin');

% Ambient space dimensions
D = 50;
% subspace dimension
K = 8;
% Angle between subspaces A-B and B-C.
thetas = [10 20 30]; % in degree
nt  = numel(thetas);
% Number of points per subspace
ng_values = [4:4:60];
nng = numel(ng_values);
SNRs = [5:5:40];
nsnrs = numel(SNRs);
Trials = 400;

average_fmeasures = zeros(nt, nsnrs, nng);
average_precisions = zeros(nt, nsnrs, nng);
average_recalls = zeros(nt, nsnrs, nng);
average_clustering_ratios = zeros(nt, nsnrs, nng);

for t=1:nt
    theta = thetas(t);
    for sn=1:nsnrs
        SNR = SNRs(sn);
        for i=1:nng
            Ng = ng_values(i);
            fmeasures = zeros(1, Trials);
            precisions = zeros(1, Trials);
            recalls = zeros(1, Trials);
            clustering_ratios = zeros(1, Trials);
            for s=1:Trials
                if mod(s, 10) == 0
                    fprintf('Theta: %d, SNR: %d dB,  Signals per subspace: %d, Trial: %d\n', theta, SNR, Ng, s);
                end
                result = SimulateSSCOMP_3Spaces(D, K, Ng, theta, SNR);
                cmpr = result.comparison;
                fmeasures(s) = cmpr.fMeasure;
                precisions(s) = cmpr.precision;
                recalls(s) = cmpr.recall;
                clustering_ratios(s) = cmpr.clusteringRatio;
            end
            average_fmeasures(t, sn, i) = mean(fmeasures);
            average_precisions(t, sn, i) = mean(precisions);
            average_recalls(t, sn, i) = mean(recalls);
            average_clustering_ratios(t, sn, i) = mean(clustering_ratios);
        end
    end
end
save(sprintf('bin/phase_transition_K=%d.mat',  K));
