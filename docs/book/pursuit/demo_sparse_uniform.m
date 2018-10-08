close all;
clearvars;
clc;
rng default;
N = 32;
K = 4;
gen = spx.data.synthetic.SparseSignalGenerator(N, K);
rep =  gen.uniform();
figure;
stem(rep, '.');
export_fig images/demo_sparse_uniform_1.png -r120 -nocrop;


