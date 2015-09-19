close all;
clear all;
clc;

data_file_path = 'bin/omp_phase_transition_gaussian_dict_gaussian_data.mat';
options.export = false;
options.export_dir = 'bin';
options.export_name = 'gaussian_dict_gaussian_data';
options.chosen_ks = [1, 2, 3, 4];
SPX_PhaseTransitionAnalysis.print_results(data_file_path, ...
    'OMP', options);

