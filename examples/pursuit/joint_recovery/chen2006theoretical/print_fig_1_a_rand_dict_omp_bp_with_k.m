close all;
clear all;
clc;
png_export = true;
pdf_export = false;

load('bin/rand_dict_bp_omp_success_with_k_figure_1.mat');

mf = SPX_Figures();

mf.new_figure('Recovery probability with K');
hold all;
plot(Ks, bp_success_with_k);
plot(Ks, omp_success_with_k);
xlabel('Sparsity level');
ylabel('probability of successful recovery');
legend('BP', 'OMP');
grid on;


