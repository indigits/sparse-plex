close all;
clear all;
clc;

data_file_path = 'bin/smv_phase_transition_snr_30db.mat';
options.export = true;
options.export_dir = 'bin';
options.export_name = 'snr_30_db';
options.chosen_ks = [2, 4, 8, 16, 32, 64];
spx.pursuit.PhaseTransitionAnalysis.print_results(data_file_path, ...
    'CoSaMP @ 30 dB', options);

