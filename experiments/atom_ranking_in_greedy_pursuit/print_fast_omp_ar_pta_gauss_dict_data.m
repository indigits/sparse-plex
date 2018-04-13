close all;
clear all;
clc;

data_file_path = 'bin/fast_omp_ar_pta_gauss_dict_bigaussian_data.mat';
options.export = false;
options.export_dir = 'bin';
options.export_name = 'gaussian_dict_gaussian_data';
%options.chosen_ks = [2, 4, 8, 16, 32, 64];
spx.pursuit.PhaseTransitionAnalysis.print_results(data_file_path, ...
    'OMP AR', options);

