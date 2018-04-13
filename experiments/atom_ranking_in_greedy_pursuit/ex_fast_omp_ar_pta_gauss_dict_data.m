%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  In this script, we perform phase transition analysis
%  of Orthogonal matching pursuit.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear all;
clc;
rng('default');
% Create the directory for storing results
[status_code,message,message_id] = mkdir('bin');
target_file_path = 'bin/fast_omp_ar_pta_gauss_dict_bigaussian_data.mat';
N = 1024;
pta = spx.pursuit.PhaseTransitionAnalysis(N);
pta.NumTrials = 200;
dict_model = @(M, N) spx.dict.simple.gaussian_dict(M, N);
data_model = @(N, K) spx.data.synthetic.SparseSignalGenerator(N, K).biGaussian;
pta.run(dict_model, data_model, @fast_omp_ar_solver);
pta.save_results(target_file_path);


