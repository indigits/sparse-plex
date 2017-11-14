close all;
clear all;
clc;


load('bin/omp_vs_gomp_comparison.mat');

mf = spx.graphics.Figures();

mf.new_figure('Iterations');

lengends = cell(5, 1);
lengends{1} = 'OMP';
for nl=1:num_ls
    lengends{nl+1} = sprintf('GOMP-%d', Ls(nl));
end
hold all;

plot(Ks, omp_average_iterations_with_k(Ks));
for nl=1:num_ls
    plot(Ks, gomp_average_iterations_with_k(Ks, nl));
end
xlabel('Sparsity level');
ylabel('Average iterations');
legend(lengends);
grid on;

mf.new_figure('Success rate');
hold all;
plot(Ks, omp_success_rates_with_k(Ks));
for nl=1:num_ls
    plot(Ks, gomp_success_rates_with_k(Ks, nl));
end
xlabel('Sparsity level');
ylabel('Success rates');
legend(lengends);
grid on;

