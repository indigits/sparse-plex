close all;
clear all;
clc;

data_file_path = 'bin/ra_mmv_phase_transition_noiseless_s_4.mat';
options.export = true;
options.export_dir = 'bin';
options.export_name = 'ra_mmv_noiseless_s_4';
options.chosen_ks = [2, 4, 8, 16, 32, 64];
options.subtitle = 'Rank Aware, Noiseless, S = 4';
spx.pursuit.PhaseTransitionAnalysis.print_results(data_file_path, ...
    'CoSaMP', options);

