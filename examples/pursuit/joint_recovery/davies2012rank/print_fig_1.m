close all;
clear all;
clc;
rng('default');

png_export = true;
pdf_export = false;

mf = SPX_Figures();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mf.new_figure('Recovery probability with K for Rank Aware Thresholding');

ra_thr = load ('bin/figure_1_ra_thresholding_success_with_K_S.mat');

hold all;
legends = cell(1, ra_thr.num_ss);
for ns=1:ra_thr.num_ss
    S = ra_thr.Ss(ns);
    plot(ra_thr.Ks, ra_thr.success_with_k(ns, :));
    legends{ns} = sprintf('S=%d', S);
end
grid on;
xlabel('Sparsity Level');
ylabel('Empirical Recovery Rate');
legend(legends);
title('Rank Aware Thresholding');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mf.new_figure('Recovery probability with K for Rank Aware Orthogonal Matching Pursuit');

ra_omp = load ('bin/figure_1_ra_omp_success_with_K_S.mat');

hold all;
legends = cell(1, ra_omp.num_ss);
for ns=1:ra_omp.num_ss
    S = ra_omp.Ss(ns);
    plot(ra_omp.Ks, ra_omp.success_with_k(ns, :));
    legends{ns} = sprintf('S=%d', S);
end
grid on;
xlabel('Sparsity Level');
ylabel('Empirical Recovery Rate');
legend(legends);
title('Rank Aware Orthogonal Matching Pursuit');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mf.new_figure('Recovery probability with K for Rank Aware Order Recursive Matching Pursuit');

ra_ormp = load ('bin/figure_1_ra_ormp_success_with_K_S.mat');

hold all;
legends = cell(1, ra_ormp.num_ss);
for ns=1:ra_ormp.num_ss
    S = ra_ormp.Ss(ns);
    plot(ra_ormp.Ks, ra_ormp.success_with_k(ns, :));
    legends{ns} = sprintf('S=%d', S);
end
grid on;
xlabel('Sparsity Level');
ylabel('Empirical Recovery Rate');
legend(legends);
title('Rank Aware Order Recursive Matching Pursuit');

