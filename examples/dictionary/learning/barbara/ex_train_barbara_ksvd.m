clear all; close all; clc;
% Problem setup parameters
rng('default');
% Create the directory for storing results
[status_code,message,message_id] = mkdir('bin');

% We will load the details of this setup from a helper function
problem = barbara_problem();
num_training_patches = size(problem.training_patches, 2);
% we will use only 1000 training patches
chosen_training_patches = randperm(num_training_patches, 500);
% We will now train the dictionary
% Create the learning algorithm
trainer = spx.dictlearn.KSVD_OMP(problem.D, problem.N);
% We fix the sparsity level of representations
ksvd.K = 4;
trainer.InitialDictionary = problem.initial_dictionary;
% Option for not touching the  DC component atom
trainer.SpecialAtoms = 1;
% We want OMP to stop when residual is small
trainer.StopOnResidualNorm = true;
trainer.StopOnResNormStable = true;
%ksvd.MaxIterations = 10;
% Learn dictionary
trainer.train(problem.training_patches(:,chosen_training_patches));
% Get the learnt dictionary
learnt_dict = trainer.Dict;

save('bin/ex_barbara_ksvd.mat', 'learnt_dict');
