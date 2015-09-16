close all;
clear all;
clc;
rng('default');

png_export = true;
pdf_export = false;



load ('bin/figure_2_dirac_fourier_dict_model_3_somp_success_with_k.mat');

mf = SPX_Figures();

mf.new_figure('Recovery probability with K for SOMP');
hold all;
legends = cell(1, num_ss);
for ns=1:num_ss
    S = Ss(ns);
    plot(Ks, omp_success_with_k(ns, :));
    legends{ns} = sprintf('S=%d', S);
end
grid on;
xlabel('Sparsity Level');
ylabel('Empirical Recovery Rate');
legend(legends, 'Location', 'southwest');