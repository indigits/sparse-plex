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
target_file_path = 'bin/smv_phase_transition_snr_30db.mat';
N = 256;
pta = SPX_PhaseTransitionAnalysis(N);
pta.SNR = 30;
% pta.NumTrials = 100;
dict_model = @(M, N) SPX_SimpleDicts.gaussian_dict(M, N);
data_model = @(N, K) SPX_SparseSignalGenerator(N, K).gaussian;
recovery_solver = @(Phi, K, y) SPX_CoSaMP_MMV(Phi, K).solve(y).Z;
pta.run(dict_model, data_model, recovery_solver);
pta.save_results(target_file_path);

