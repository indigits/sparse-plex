% Initialize
clear all; close all; clc; 

% Problem setup parameters
rng('default');
% rng(54321);
problem = SPX_DictionaryLearningProblems.problem_random_dict();

% Create the learning algorithm
trainer = SPX_MOD_OMP(problem.D, problem.N);
% Provide a random dictionary as initial dictionary
trainer.InitialDictionary = randn(problem.N, problem.D);
% Provide true dictionary for reference
trainer.TrueDictionary = problem.true_dictionary;
% We fix the sparsity level of representations
trainer.K = problem.K;
% Learn dictionary
trainer.train(problem.signals);
% Get the learnt dictionary
LearntDict = trainer.Dict;

