close all;
clear all;
clc;


load('bin/omp_vs_mc_omp_comparison.mat');

mf = spx.graphics.Figures();

mf.new_figure('Iterations');

hold all;

plot(Ks, omp_average_iterations_with_k(Ks));
plot(Ks, mcomp_average_iterations_with_k(Ks));
xlabel('Sparsity level');
ylabel('Average iterations');
legend({'OMP', 'MC-OMP'});
grid on;

mf.new_figure('Success rate');
hold all;
plot(Ks, omp_success_rates_with_k(Ks));
plot(Ks, mcomp_success_rates_with_k(Ks));
xlabel('Sparsity level');
ylabel('Success rates');
legend({'OMP', 'MC-OMP'});
grid on;

