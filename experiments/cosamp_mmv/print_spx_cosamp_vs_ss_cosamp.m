close all;
clear all;
clc;


load('bin/sscosamp_vs_spx_cosamp.mat');

mf = spx.graphics.Figures();

mf.new_figure('Iterations');

hold all;

plot(Ks, sscosamp_average_iterations_with_k);
plot(Ks, csmp_average_iterations_with_k);
xlabel('Sparsity level');
ylabel('Average iterations');
legend({'SS-COSAMP', 'SPX-COSAMP'});
grid on;

mf.new_figure('Success rate');
hold all;
plot(Ks, sscosamp_success_rates_with_k);
plot(Ks, csmp_success_rates_with_k);
xlabel('Sparsity level');
ylabel('Success rates');
legend({'SS-COSAMP', 'SPX-COSAMP'});
grid on;

