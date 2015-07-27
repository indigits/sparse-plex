% Initialize
clear all; close all; clc; 
% Create the directory for storing results
[status_code,message,message_id] = mkdir('bin');

% Problem setup parameters
rng('default');
% rng(54321);
problem = SPX_DictionaryLearningProblems.problem_random_dict();

% Create the learning algorithm
trainer = SPX_KSVD_CC_OMP(problem.D, problem.N);
% Provide a random dictionary as initial dictionary
trainer.InitialDictionary = randn(problem.N, problem.D);
% We fix the sparsity level of representations
trainer.K = problem.K;
% Tracker for tracking dictionary update progress
tracker = SPX_DictionaryLearningTracker();
% Provide true dictionary for reference
tracker.TrueDictionary = problem.true_dictionary;
% Attach tracker with trainer
trainer.Tracker = @tracker.dictionary_update_callback;
% Learn dictionary
trainer.train(problem.signals);
% Get the learnt dictionary
LearntDict = trainer.Dict;

save('bin/ex_dict_learn_ksvd_cc.mat', 'problem', 'tracker');
