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
target_file_path = 'bin/mmv_phase_transition_noiseless_s_32.mat';
N = 256;
S = 32;
pta = spx.pursuit.PhaseTransitionAnalysis(N);
% pta.NumTrials = 100;
dict_model = @(M, N) spx.dict.simple.gaussian_dict(M, N);
data_model = @(N, K) spx.data.synthetic.SparseSignalGenerator(N, K, S).gaussian;
recovery_solver = @(Phi, K, y) spx.pursuit.single.CoSaMP_MMV(Phi, K).solve(y).Z;
pta.run(dict_model, data_model, recovery_solver);
pta.save_results(target_file_path);

