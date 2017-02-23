close all;
clear all;
clc;

data_file_path = 'bin/smv_phase_transition_noiseless.mat';
options.export = true;
options.export_dir = 'bin';
options.export_name = 'smv_noiseless';
options.chosen_ks = [2, 4, 8, 16, 32, 64];
options.subtitle = 'Noiseless';
spx.pursuit.PhaseTransitionAnalysis.print_results(data_file_path, ...
    'CoSaMP', options);

