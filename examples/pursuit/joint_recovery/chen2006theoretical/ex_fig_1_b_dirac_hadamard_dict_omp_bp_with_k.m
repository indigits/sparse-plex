close all;
clear all;
clc;
rng('default');
% Create the directory for storing images
[status_code,message,message_id] = mkdir('bin');
% Signal space
M = 16;
% Representation space 
N = M * 2;
% Number of signals
S = 5;

% Sensing matrix
Phi = spx.dict.simple.dirac_hadamard_dict(M);
phi_props = spx.dict.Properties(Phi);
mu = phi_props.coherence();
upper_limit  = ceil((1 + 1/mu) / 2) + 15;
% upper_limit = 4;
% Sparsity levels
Ks = 2:upper_limit;
num_ks = length(Ks);
num_trials = 500;

bp_success_with_k = zeros(1, num_ks);
omp_success_with_k = zeros(0, num_ks);

threshold = 1e-6;
for nk=1:num_ks
    K = Ks(nk);
    num_omp_successes = 0;
    num_bp_successes = 0;
    for nt=1:num_trials
        % Construct the signal generator.
        gen  = spx.data.synthetic.SparseSignalGenerator(N, K, S);
        % Generate bi-uniform signals
        X = gen.gaussian;


        % Measurement vectors
        Y = Phi * X;

        bp_solver = spx.pursuit.joint.BasisPursuit(Phi);
        result = bp_solver.solve_l1_l1(Y);
        % Solution vectors
        X_BP = result.Z;
        residual_norm_bp = norm(X - X_BP, 'fro');
        bp_success = residual_norm_bp < threshold;
        num_bp_successes = num_bp_successes + bp_success;

        % OMP MMV solver instance
        omp_solver = spx.pursuit.joint.OrthogonalMatchingPursuit(Phi, K);
        % Solve the sparse recovery problem
        result = omp_solver.solve(Y);
        % Solution vectors
        X_OMP = result.Z;
       residual_norm_omp = norm(X - X_OMP, 'fro');
       omp_success  = residual_norm_omp < threshold;
       num_omp_successes = num_omp_successes + omp_success;


        fprintf('K=%d, trial=%d, residual omp: %e, bp: %e\n'...
            , K, nt, residual_norm_omp, residual_norm_bp);
    end
    bp_success_with_k(nk) = num_bp_successes / num_trials;
    omp_success_with_k(nk) = num_omp_successes / num_trials;
end

save ('bin/dirac_hadamard_dict_bp_omp_success_with_k_figure_1.mat');

