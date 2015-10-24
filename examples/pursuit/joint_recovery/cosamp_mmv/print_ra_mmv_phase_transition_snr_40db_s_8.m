close all;
clear all;
clc;

data_file_path = 'bin/ra_mmv_phase_transition_snr_40db_s_8.mat';
options.export = true;
options.export_dir = 'bin';
options.export_name = 'ra_mmv_snr_40_db_s_8';
options.chosen_ks = [2, 4, 8, 16, 32, 64];
options.subtitle = 'Rank Aware, SNR=40dB s=8';
SPX_PhaseTransitionAnalysis.print_results(data_file_path, ...
    'CoSaMP', options);


