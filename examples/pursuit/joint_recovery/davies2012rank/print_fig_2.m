close all;
clear all;
clc;
rng('default');

png_export = true;
pdf_export = false;

mf = SPX_Figures();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mf.new_figure('Recovery probability with S for different MMV recovery algorithms');

load ('bin/figure_2_success_with_s_comparison.mat');

hold all;
legends = cell(1, 4);

plot(Ss, success_with_s.ra_ormp, '-+');
legends{1} = 'RA-ORMP';
plot(Ss, success_with_s.ra_omp, '-o');
legends{2} = 'RA-OMP';
plot(Ss, success_with_s.somp, '-s');
legends{3} = 'SOMP';
plot(Ss, success_with_s.ra_thresholding, '-d');
legends{4} = 'RA-Thresholding';

grid on;
xlabel('Number of signals');
ylabel('Recovery Probability');
legend(legends, 'Location', 'southeast');
title('Comparison of recovery performance for MMV algorithms');

