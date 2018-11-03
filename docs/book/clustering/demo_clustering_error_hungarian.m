clc; close all; clearvars;

% Original data
% A  = [1 1 1 1 1 2 2 2 3 3 3 3 4 4];
% B  = [2 3 2 2 2 4 4 4 3 3 3 3 1 2];

% shuffled data
A  = [2 1 3 2 4 2 1 1 1 1 4 3 3 3];
B  = [4 2 3 4 2 4 2 2 3 2 1 3 3 3];

num_labels = numel(A)

mapped_B = bestMap(A, B)'

mistakes = A ~= mapped_B

num_mistakes = sum(mistakes)

clustering_error  = num_mistakes / num_labels

clustering_error_perc = clustering_error * 100

clustering_acc_perc = 100 -clustering_error_perc

