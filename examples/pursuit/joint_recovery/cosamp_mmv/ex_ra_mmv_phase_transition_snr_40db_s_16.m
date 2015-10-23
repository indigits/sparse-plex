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
target_file_path = 'bin/ra_mmv_phase_transition_snr_40db_s_16.mat';
N = 256;
S = 16;
pta = SPX_PhaseTransitionAnalysis(N);
pta.SNR = 40;

% options for CoSaMP MMV solver
solver_options.RankAwareResidual = true;
P = 2;

% pta.NumTrials = 100;
dict_model = @(M, N) SPX_SimpleDicts.gaussian_dict(M, N);
data_model = @(N, K) SPX_SparseSignalGenerator(N, K, S).gaussian;
recovery_solver = @(Phi, K, y) SPX_CoSaMP_MMV(Phi, K, P, solver_options).solve(y).Z;
pta.run(dict_model, data_model, recovery_solver);
pta.save_results(target_file_path);

