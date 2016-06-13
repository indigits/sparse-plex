close all;
clear all;
clc;
rng('default');

png_export = true;
pdf_export = false;



load ('bin/figure_1_spherical_dict_model_1_somp_success_with_k.mat');

mf = spx.graphics.Figures();

mf.new_figure('Recovery probability with K for SOMP');
hold all;
legends = cell(1, num_ss);
for ns=1:num_ss
    S = Ss(ns);
    plot(Ks, bp_success_with_k(ns, :));
    legends{ns} = sprintf('S=%d', S);
end
grid on;
xlabel('Sparsity Level');
ylabel('Empirical Recovery Rate');
legend(legends);