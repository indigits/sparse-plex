close all;
clear all;
clc;
png_export = true;
pdf_export = false;

load('bin/noiseless_s=1_hamming_distances_omp_mmv.mat');

mf = SPX_Figures();

mf.new_figure('Average Hamming distance');

average_hamming_distances = mean(hamming_distances, 2);
std_hamming_distances = std(hamming_distances, 0, 2);

errorbar(Ks, average_hamming_distances, std_hamming_distances, '-o');
xlabel('Sparsity level K');
ylabel('Average Hamming distance');
xlim([60, 125]);
ylim([0, 0.45]);
grid on;