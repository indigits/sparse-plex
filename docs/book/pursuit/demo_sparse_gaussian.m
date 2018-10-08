close all;
clearvars;
clc;
rng default;
N = 128;
K = 8;
gen = spx.data.synthetic.SparseSignalGenerator(N, K);
rep =  gen.gaussian();
figure;
stem(rep, '.');
export_fig images/demo_sparse_gaussian_1.png -r120 -nocrop;


