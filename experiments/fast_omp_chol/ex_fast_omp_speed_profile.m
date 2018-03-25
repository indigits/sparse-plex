close all;
clearvars;
powers = 8:12;
Ns = 2.^powers;
Ms = Ns / 2;
Ks = Ms / 32;
nc = numel(powers);
omp_times = zeros(nc, 1);
chol_omp_times = zeros(nc, 1);
fast_omp_times = zeros(nc, 1);
trials = 20;
% warm up
M = 256;
N = 512;
K = 4;
Phi = spx.dict.simple.gaussian_mtx(M, N);
x = spx.data.synthetic.SparseSignalGenerator(N, K).gaussian;
y = Phi * x;
for t=1:4
    spx.fast.omp(Phi, y, K, 0);
    spx.pursuit.single.omp_chol(Phi, y, K, 0);
    spx.pursuit.single.OrthogonalMatchingPursuit(Phi, K).solve(y);
end

% iterate over configurations
for c=1:nc
    % iterate over trials
    N = Ns(c);
    M = Ms(c);
    K = Ks(c);
    fprintf('Config [%d]: N: %d, M: %d, K: %d\n', c, N, M, K);
    rng('default');
    Phi = spx.dict.simple.gaussian_mtx(M, N);
    x = spx.data.synthetic.SparseSignalGenerator(N, K).gaussian;
    y = Phi * x;
    tstart = tic;
    for t=1:trials
        spx.pursuit.single.OrthogonalMatchingPursuit(Phi, K).solve(y);
    end
    total_time = toc(tstart);
    omp_times(c) = total_time / trials;

    tstart = tic;
    for t=1:trials
        spx.pursuit.single.omp_chol(Phi, y, K, 0);
    end
    total_time = toc(tstart);
    chol_omp_times(c) = total_time / trials;
    
    tstart = tic;
    for t=1:trials
        spx.fast.omp(Phi, y, K, 0);
    end
    total_time = toc(tstart);
    fast_omp_times(c) = total_time / trials;
end
report.powers = powers;
report.Ns  = Ns;
report.Ms  = Ms;
report.Ks  = Ks;
report.nc = nc;
report.trials = trials;
report.omp_times = omp_times;
report.chol_omp_times = chol_omp_times;
report.fast_omp_times = fast_omp_times;
% Create the directory for storing results
[status_code,message,message_id] = mkdir('bin');
target_file_path = 'bin/fast_omp_performance_profile.mat';
fprintf('Saving report.\n');
save(target_file_path, 'report');

combined = [omp_times chol_omp_times fast_omp_times];
chol_omp_gains = omp_times ./ chol_omp_times;
fast_omp_gains = omp_times ./ fast_omp_times;
gains = [chol_omp_gains fast_omp_gains];