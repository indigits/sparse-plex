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
target_file_path = 'bin/omp_phase_transition_gaussian_dict_gaussian_data.mat';
N = 64;
pta = SPX_PhaseTransitionAnalysis(N);
% pta.NumTrials = 100;
dict_model = @(M, N) SPX_SimpleDicts.gaussian_dict(M, N);
data_model = @(N, K) SPX_SparseSignalGenerator(N, K).gaussian;
recovery_solver = @(Phi, K, y) spx.pursuit.single.OrthogonalMatchingPursuit(Phi, K).solve(y).z;
pta.run(dict_model, data_model, recovery_solver);
pta.save_results(target_file_path);

