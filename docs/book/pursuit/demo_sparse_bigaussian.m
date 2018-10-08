close all;
clearvars;
clc;
rng default;
N = 128;
K = 8;
gen = spx.data.synthetic.SparseSignalGenerator(N, K);
rep =  gen.biGaussian();
figure;
stem(rep, '.');
export_fig images/demo_sparse_bigaussian_1.png -r120 -nocrop;

nz_rep = rep(rep~=0)';
anz_rep = abs(nz_rep);
dr = max(anz_rep) / min(anz_rep);



