close all;
clear all;
clc;


load('bin/fig_1.mat');

mf = SPX_Figures();

mf.new_figure('Iterations');

hold all;

plot(Ks, nhtp_average_iterations_with_k);
plot(Ks, csmp_average_iterations_with_k);
xlabel('Sparsity level');
ylabel('Average iterations');
legend({'NHTP', 'CSMP'});
grid on;

mf.new_figure('Success rate');
hold all;
plot(Ks, nhtp_success_rates_with_k);
plot(Ks, csmp_success_rates_with_k);
xlabel('Sparsity level');
ylabel('Success rates');
legend({'NHTP', 'CSMP'});
grid on;

