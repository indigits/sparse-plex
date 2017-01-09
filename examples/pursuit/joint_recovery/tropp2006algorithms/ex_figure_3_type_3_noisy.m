%TODO : It's unclear how noise is added.

close all;
clear all;
clc;
rng('default');
% Create the directory for storing images
[status_code,message,message_id] = mkdir('bin');

% Signal space dimension
N = 256;
% Dictionary
Dict = spx.dict.simple.dirac_fourier_dict(N);
[N, D] = size(Dict);
% sparsity levels
Ks = 2:4;
num_ks = length(Ks);
% Number of signals
Ss = 2:6;
nums_ss = length(Ss);
% number of trials
num_trials = 500;
SNRs = [10 13 16 20];
num_snrs = length(SNRs);
% Raw data for Hamming distances
hamming_distances = zeros(num_ks, num_snrs, nums_ss, num_trials);

for nk=1:num_ks
    K = Ks(nk);
    for nsnr=1:num_snrs
        SNR = SNRs(nsnr);
        % Standard deviation for the Gaussian noise
        % sigma  = db2mag(-SNR);
        % sigma = sqrt(K) * 10^(-SNR/20);
        for ns=1:nums_ss
            S = Ss(ns);
            % Noise generator
            ng = spx.data.noise.Basic(N, S);
            % Trials
            for trial=1:num_trials
                fprintf('K: %d, SNR: %d dB, S: %d, trial: %d\n', K, SNR, S, trial);
                % Construct the signal generator.
                gen  = spx.data.synthetic.SparseSignalGenerator(D, K, S);
                true_support = gen.Omega;
                % Generate sparse signals
                X = gen.rademacher();
                % Measurement vectors
                Y0 = Dict.apply(X);
                % Create noises at the specified SNR level
                noises = spx.data.noise.Basic.createNoise4(Y0, SNR);
                % noises  = ng.gaussian(sigma);
                % Created corrupted signals
                Y = Y0 + noises;
                % OMP MMV solver instance
                solver = spx.pursuit.joint.OrthogonalMatchingPursuit(Dict, K);
                % Solve the sparse recovery problem
                result = solver.solve(Y);
                % Solution vector
                Z = result.Z;
                % fprintf('Residual Frobenius norm: %f\n', result.residual_frobenius_norm);
                recovered_support = result.support;
                common_support  = intersect(true_support, recovered_support);
                nc = length(common_support);
                similarity =  nc / K;
                % fprintf('Number of correctly recovered atoms: %d, similarity: %f\n', nc, similarity);
                hamming_distance = 1 - similarity;
                hamming_distances(nk, nsnr, ns, trial) = hamming_distance;
            end
        end
    end
end


save('bin/noisy_hamming_distances_k_s_snr_omp_mmv.mat');

