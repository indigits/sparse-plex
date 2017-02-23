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
target_file_path = 'bin/ra_mmv_phase_transition_snr_30db_s_16.mat';
N = 256;
S = 16;
pta = spx.pursuit.PhaseTransitionAnalysis(N);
pta.SNR = 30;

% options for CoSaMP MMV solver
solver_options.RankAwareResidual = true;
P = 2;

% pta.NumTrials = 100;
dict_model = @(M, N) spx.dict.simple.gaussian_dict(M, N);
data_model = @(N, K) spx.data.synthetic.SparseSignalGenerator(N, K, S).gaussian;
recovery_solver = @(Phi, K, y) spx.pursuit.joint.CoSaMP(Phi, K, P, solver_options).solve(y).Z;
pta.run(dict_model, data_model, recovery_solver);
pta.save_results(target_file_path);

