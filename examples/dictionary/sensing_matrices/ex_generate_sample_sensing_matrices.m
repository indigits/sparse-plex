%% Initialization code
clear all; close all; clc; rng('default');
% Create the directory for storing images
[status_code,message,message_id] = mkdir('bin');


% This script generates a set of sample sensing matrices
% used for various experiments.


% Length of each signal
N = 1000;
% Dimensions of observation spaces
Ms = [10 20 50 100 150 200 300 400 500];
% Number of sets of sensing matrices which we will produce
R = 2;

% We create a cell array to hold the sensing matrices
% Each column in the cell array is one set of sensing matrices
% for different values of M.
fprintf('Creating Gaussian sensing matrices');
gaussianSensingMatrices = cell(length(Ms), R);
for c=1:R
    fprintf('\n\nSet no: %d\n\n', c);
    % We producce Gaussian sensing matrices for each value of M
    for i=1:length(Ms)
        M  = Ms(i);
        % Create a sensing matrix for this size
        phi = SPX_SimpleDicts.gaussian_mtx(M, N);
        fprintf('MxN: %dx%d\n', M, N);
        gaussianSensingMatrices{i, c} = phi;
    end
end
fprintf('Creating Rademacher sensing matrices');
radamacherSensingMatrices = cell(length(Ms), R);
for c=1:R
    fprintf('\n\nSet no: %d\n\n', c);
    % We producce Rademacher sensing matrices for each value of M
    for i=1:length(Ms)
        M  = Ms(i);
        % Create a sensing matrix for this size
        phi = SPX_SimpleDicts.rademacher_mtx(M, N);
        fprintf('MxN: %dx%d\n', M, N);
        radamacherSensingMatrices{i, c} = phi;
    end
end
fprintf('Saving gaussianSensingMatrices:\n');
save('bin/gaussian_sensing_matrices.mat', 'gaussianSensingMatrices', 'Ms');
fprintf('Saving radamacherSensingMatrices:\n');
save('bin/radamacher_sensing_matrices.mat', 'radamacherSensingMatrices', 'Ms');


