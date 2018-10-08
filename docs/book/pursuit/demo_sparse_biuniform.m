close all;
clearvars;
clc;
rng default;
N = 32;
K = 4;
gen = spx.data.synthetic.SparseSignalGenerator(N, K);
rep =  gen.biUniform();
figure;
stem(rep, '.');
export_fig images/demo_sparse_biuniform_1.png -r120 -nocrop;

rep =  gen.biUniform(2, 4);
figure;
stem(rep, '.');
export_fig images/demo_sparse_biuniform_2.png -r120 -nocrop;

