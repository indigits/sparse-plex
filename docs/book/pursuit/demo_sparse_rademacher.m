close all;
clearvars;
clc;
rng default;
N = 128;
K = 8;
gen = spx.data.synthetic.SparseSignalGenerator(N, K);
rep =  gen.rademacher();
figure;
stem(rep, '.');
export_fig images/demo_sparse_rademacher_1.png -r120 -nocrop;


