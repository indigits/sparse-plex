close all;
clear all;
clc;

data_file_path = 'bin/mmv_phase_transition_snr_30db_s_2.mat';
options.export = true;
options.export_dir = 'bin';
options.export_name = 'snr_30_db_s_2';
options.chosen_ks = [2, 4, 8, 16, 32, 64];
options.subtitle = 'MMV, SNR=30dB s=2';
SPX_PhaseTransitionAnalysis.print_results(data_file_path, ...
    'CoSaMP', options);

