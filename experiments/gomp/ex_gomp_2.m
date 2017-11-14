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
gomp_success = 0;
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



    % GOMP solver instance
    solver = spx.pursuit.single.GOMP(Phi, K);
    %solver.L = 2;
    % Solve the sparse recovery problem
    gomp_result = solver.solve(y);
    % Solution vector
    z = gomp_result.z;
    gomp_stats = spx.commons.sparse.recovery_performance(Phi, K, y, x, z);
    %fprintf('GOMP\n');
    %spx.commons.sparse.print_recovery_performance(gomp_stats);

    fprintf('K=%d, Trial: %d, OMP: %s, GOMP: %s\n', ...
        K, nt, spx.io.true_false_short(omp_stats.success), ...
        spx.io.true_false_short(gomp_stats.success));
    omp_success = omp_success  + omp_stats.success;
    gomp_success = gomp_success  + gomp_stats.success;
end
fprintf('TOTAL: OMP : %d, GOMP: %d\n', omp_success, gomp_success);

