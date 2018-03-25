%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  In this script, we perform phase transition analysis
%  of fast implementation of OMP with Cholesky updates.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear all;
clc;
rng('default');
% Create the directory for storing results
[status_code,message,message_id] = mkdir('bin');
target_file_path = 'bin/omp_phase_transition_gaussian_dict_gaussian_data.mat';
N = 64;
pta = spx.pursuit.PhaseTransitionAnalysis(N);
% pta.NumTrials = 100;
dict_model = @(M, N) spx.dict.simple.gaussian_mtx(M, N);
data_model = @(N, K) spx.data.synthetic.SparseSignalGenerator(N, K).gaussian;
recovery_solver = @(Phi, K, y) spx.fast.omp(Phi, y, K, 0);
pta.run(dict_model, data_model, recovery_solver);
pta.save_results(target_file_path);

