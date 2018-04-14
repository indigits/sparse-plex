% Compare MATLAB vs C implementations of GOMP
close all;
clear all;
clc;
rng('default');
% Create the directory for storing images
[status_code,message,message_id] = mkdir('bin');

% Signal space 
N = 1000;
% Number of measurements
M = 200;
K = 50;

m_gomp_success = 0;
c_gomp_success = 0;
m_gomp_time = 0;
c_gomp_time = 0;
for nt=1:100
    % Sensing matrix
    rng(nt);
    Phi = spx.dict.simple.gaussian_dict(M, N);
    % Construct the signal generator.
    gen  = spx.data.synthetic.SparseSignalGenerator(N, K);
    % Generate bi-uniform signals
    x = gen.gaussian;
    % Measurement vectors
    y = Phi.apply(x);


    tstart = tic;
    % GOMP solver instance
    solver = spx.pursuit.single.GOMP(Phi, K);
    %solver.L = 2;
    % Solve the sparse recovery problem
    m_gomp_result = solver.solve(y);
    % Solution vector
    z = m_gomp_result.z;
    m_gomp_time = m_gomp_time + toc(tstart);
    m_gomp_stats = spx.commons.sparse.recovery_performance(Phi, K, y, x, z);
    %fprintf('GOMP\n');
    %spx.commons.sparse.print_recovery_performance(m_gomp_stats);



    tstart = tic;
    % GOMP solver instance
    L = 2;
    options.ls_method = 'ls';
    z = spx.fast.gomp(double(Phi), y, K, L, 1e-3, options);
    c_gomp_time = c_gomp_time + toc(tstart);
    c_gomp_stats = spx.commons.sparse.recovery_performance(Phi, K, y, x, z);
    %fprintf('GOMP\n');
    %spx.commons.sparse.print_recovery_performance(c_gomp_stats);

    fprintf('K=%d, Trial: %d, M-GOMP: %s, C-GOMP: %s\n', ...
        K, nt, spx.io.true_false_short(m_gomp_stats.success), ...
        spx.io.true_false_short(c_gomp_stats.success));
    m_gomp_success = m_gomp_success  + m_gomp_stats.success;
    c_gomp_success = c_gomp_success  + c_gomp_stats.success;
end
fprintf('TOTAL: OMP : %d, GOMP: %d\n', m_gomp_success, c_gomp_success);

t1 = m_gomp_time;
t2 = c_gomp_time;
gain_x = t1/t2;
if t1 > t2
    gain_perc = (t1 - t2) * 100/ t1;
else
    gain_perc = (t1 - t2) * 100/ t2;
end
fprintf('Time: M-GOMP, %.2f s, C-GOMP: %.2f s, gain: %.2f (%.1f %%)\n', t1, t2, gain_x, gain_perc);

