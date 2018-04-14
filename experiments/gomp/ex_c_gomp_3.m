% Compare MATLAB vs C implementations of GOMP
close all;
clear all;
clc;
% Create the directory for storing images
[status_code,message,message_id] = mkdir('bin');

% Signal space 
N = 1000;
% Number of measurements
M = 200;
K = 50;

% Sensing matrix
rng(1);
Phi = spx.dict.simple.gaussian_dict(M, N);
% Construct the signal generator.
gen  = spx.data.synthetic.SparseSignalGenerator(N, K);
% Generate bi-uniform signals
x = gen.gaussian;
% Measurement vectors
y = Phi.apply(x);


% GOMP solver instance
solver = spx.pursuit.single.GOMP(Phi, K);
solver.Verbose = true;
%solver.L = 2;
% Solve the sparse recovery problem
m_gomp_result = solver.solve(y);
% Solution vector
z = m_gomp_result.z;
m_gomp_stats = spx.commons.sparse.recovery_performance(Phi, K, y, x, z);
%fprintf('GOMP\n');
spx.commons.sparse.print_recovery_performance(m_gomp_stats);



% GOMP solver instance
L = 2;
options.ls_method = 'chol';
options.verbose = 2;
z = spx.fast.gomp(double(Phi), y, K, L, 1e-6, options);
c_gomp_stats = spx.commons.sparse.recovery_performance(Phi, K, y, x, z);
%fprintf('GOMP\n');
spx.commons.sparse.print_recovery_performance(c_gomp_stats);

fprintf('K=%d, M-GOMP: %s, C-GOMP: %s\n', ...
    K, spx.io.true_false_short(m_gomp_stats.success), ...
    spx.io.true_false_short(c_gomp_stats.success));

