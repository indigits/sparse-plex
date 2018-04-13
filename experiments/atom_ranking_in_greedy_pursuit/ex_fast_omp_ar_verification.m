clc;
clearvars;
close all;
M = 512;
N = 1024;
K = 5;
S = 1000;
Phi = spx.dict.simple.gaussian_mtx(M, N);
G = Phi' * Phi;
X = spx.data.synthetic.SparseSignalGenerator(N, K, S).biGaussian;
Y = Phi * X;
options.verbose = 1;
tstart = tic;
X1 = spx.fast.omp(Phi, Y, K, 1e-3, options);
t1 = toc(tstart);
options.verbose = 1;
options.threshold_factor = 2;
options.reset_cycle = 4;
tstart = tic;
X2 =  spx.fast.omp_ar(Phi, Y, K, 1e-3, options);
t2 = toc(tstart);
cmpare = spx.commons.SparseSignalsComparison(X1, X2, K);
cmpare.summarize();

failures = sum(cmpare.support_similarity_ratios() ~= 1);
fprintf('Failed detections %d (%.2f %%)\n', failures, failures* 100 / S);
gain_x = t1/t2;
if t1 > t2
    gain_perc = (t1 - t2) * 100/ t1;
else
    gain_perc = (t1 - t2) * 100/ t2;
end
fprintf('Time: OMP, %.2f s, OMP-AR: %.2f s, gain: %.2f (%.1f %%)\n', t1, t2, gain_x, gain_perc);
