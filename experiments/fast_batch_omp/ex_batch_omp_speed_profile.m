close all;
clearvars;
rng('default');
powers = 1:5;
Ss = 10.^powers;
nc = numel(powers);
N = 1024;
M = N / 2;
K = M / 32;
omp_times = zeros(nc, 1);
batch_omp_times = zeros(nc, 1);
Phi = spx.dict.simple.gaussian_mtx(M, N);
for c=1:nc
    S = Ss(c);
    fprintf('c: %d, S: %d ', c, S);
    X = spx.data.synthetic.SparseSignalGenerator(N, K, S).gaussian;
    Y = Phi * X;

    tstart = tic;
    X1 = spx.fast.omp(Phi, Y, K, 0);    
    total_time1 = toc(tstart);
    omp_times(c) = total_time1;
    fprintf('OMP: %.3f s  ', total_time1);

    tstart = tic;
    G = Phi' * Phi;
    DtY = Phi' * Y;
    total_time2 = toc(tstart);
    X3 = spx.fast.batch_omp([], [], G, DtY, K, 0);
    total_time3 = toc(tstart);
    batch_omp_times(c) = total_time3;
    fprintf('Batch OMP: %.3f s, %.3f s  ', total_time2, total_time3);
    fprintf('Gain: %.2f %.2f \n', ...
        total_time1 / total_time3, ...
        total_time1 / (total_time3 - total_time2));
end
combined = [omp_times batch_omp_times];
batch_omp_gains = omp_times ./ batch_omp_times;
% Collect data to be saved.
report.powers = powers;
report.Ss = Ss;
report.N = N;
report.M = M;
report.K = K;
report.omp_times = omp_times;
report.batch_omp_times = batch_omp_times;
report.batch_omp_gains = batch_omp_gains;
% Create the directory for storing results
[status_code,message,message_id] = mkdir('bin');
target_file_path = 'bin/batch_omp_performance_profile.mat';
fprintf('Saving report.\n');
save(target_file_path, 'report');
