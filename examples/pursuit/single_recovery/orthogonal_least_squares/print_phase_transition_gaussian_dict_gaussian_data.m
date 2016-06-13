close all;
clear all;
clc;

data_file_path = 'bin/ols_phase_transition_gaussian_dict_gaussian_data.mat';
options.export = false;
options.export_dir = 'bin';
options.export_name = 'gaussian_dict_gaussian_data';
options.chosen_ks = [2, 4, 8, 16, 32, 64];
spx.pursuit.PhaseTransitionAnalysis.print_results(data_file_path, ...
    'OLS', options);

