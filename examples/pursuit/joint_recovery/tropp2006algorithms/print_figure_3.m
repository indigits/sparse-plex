close all;
clear all;
clc;
png_export = true;
pdf_export = false;

load('bin/noisy_hamming_distances_k_s_snr_omp_mmv.mat');

mf = spx.graphics.Figures();

mf.new_figure('Average Hamming distance');
hold on;
avg_hamming_distances = mean(hamming_distances, 4);

legends = cell(1, num_ks);
for nk=1:num_ks
    K = Ks(nk);
    k_hamming_distances = avg_hamming_distances(nk, :, :);
    k_hamming_distances = reshape(k_hamming_distances, num_snrs, nums_ss);
    plot(Ss, k_hamming_distances, '-o');
    legends{nk} = sprintf('K=%d', K);
end
legend(legends);

