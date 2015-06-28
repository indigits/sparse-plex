clear all; close all; clc; rng('default');

% Ambient space dimensions
D = 50;
% subspace dimension
K = 8;
% Angle between subspaces A-B and B-C.
thetas = [4:2:40]; % in degree
nt  = numel(thetas);
% Number of points per subspace
ng_values = [4:2:60];
nng = numel(ng_values);
SNRs = [15, 25 35];
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
                if mod(s, 1) == 0
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
save(sprintf('bin/phase_transition_theta_signals_K=%d.mat',  K));
