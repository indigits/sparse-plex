close all;
clear all;
clc;
rng('default');
% Create the directory for storing images
[status_code,message,message_id] = mkdir('bin');

N = 128;

Dict = SPX_SimpleDicts.dirac_fourier_dict(N);
[N, D] = size(Dict);
% sparsity levels
Ks = 60:128;
num_ks = length(Ks);
% Number of signals
S = 1;
% number of trials
num_trials = 500;


hamming_distances = zeros(num_ks, num_trials);
for nk=1:num_ks
    K = Ks(nk);
    for trial=1:num_trials
        fprintf('K: %d, trial: %d\n', K, trial);
        % Construct the signal generator.
        gen  = SPX_SparseSignalGenerator(D, K, S);
        true_support = gen.Omega;
        X = gen.gaussian();
        % Measurement vectors
        Y = Dict.apply(X);
        % OMP MMV solver instance
        solver = SPX_OMP_MMV(Dict, K);
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
        hamming_distances(nk, trial) = hamming_distance;
    end
end

save('bin/noiseless_s=1_hamming_distances_omp_mmv.mat');

