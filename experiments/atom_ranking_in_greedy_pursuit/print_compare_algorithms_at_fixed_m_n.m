close all;
clear all;
clc;
png_export = true;
pdf_export = false;


load('bin/omp_vs_omp_ar_comparison.mat');

mf = spx.graphics.Figures();

mf.new_figure('Average matchings per iteration');

hold all;

plot(Ks, ones(num_ks, 1) * N);

plot(Ks, omp_ar_average_matches_with_k);
xlabel('Sparsity level');
ylabel('Average number of matchings per iteration');
legend({'OMP', 'AR-OMP'});
grid on;

mf.new_figure('Success rate');
hold all;
plot(Ks, omp_success_rates_with_k, '-.');
plot(Ks, omp_ar_success_rates_with_k, ':');
xlabel('Sparsity level');
ylabel('Success rates');
legend({'OMP', 'OMP-AR'});
grid on;

