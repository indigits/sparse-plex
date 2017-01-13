close all;
clear all;
clc;
%rng('default');
% Create the directory for storing images
[status_code,message,message_id] = mkdir('bin');

% Signal space 
N = 1000;
% Number of measurements
M = 200;
K = 50;

omp_success = 0;
mc_omp_success = 0;
for nt=1:100
    % Sensing matrix
    Phi = spx.dict.simple.gaussian_dict(M, N);
    % Construct the signal generator.
    gen  = spx.data.synthetic.SparseSignalGenerator(N, K);
    % Generate bi-uniform signals
    x = gen.gaussian;
    % Measurement vectors
    y = Phi.apply(x);


    % OMP solver instance
    solver = spx.pursuit.single.OrthogonalMatchingPursuit(Phi, K);
    % Solve the sparse recovery problem
    omp_result = solver.solve(y);
    % Solution vector
    z = omp_result.z;
    omp_stats = spx.commons.sparse.recovery_performance(Phi, K, y, x, z);
    %fprintf('OMP\n');
    %spx.commons.sparse.print_recovery_performance(omp_stats);



    % MC-OMP solver instance
    solver = spx.pursuit.single.MC_OMP(Phi, K);
    %solver.BranchingFactor = 4;
    %solver.MaxCandidatesToRetain = 8;
    % Solve the sparse recovery problem
    mcomp_result = solver.solve(y);
    % Solution vector
    z = mcomp_result.z;
    mcomp_stats = spx.commons.sparse.recovery_performance(Phi, K, y, x, z);
    %fprintf('MC-OMP\n');
    %spx.commons.sparse.print_recovery_performance(mcomp_stats);

    fprintf('K=%d, Trial: %d, OMP: %s, MC-OMP: %s\n', ...
        K, nt, spx.io.true_false_short(omp_stats.success), ...
        spx.io.true_false_short(mcomp_stats.success));
    omp_success = omp_success  + omp_stats.success;
    mc_omp_success = mc_omp_success  + mcomp_stats.success;
end
fprintf('TOTAL: OMP : %d, MC-OMP: %d\n', omp_success, mc_omp_success);

