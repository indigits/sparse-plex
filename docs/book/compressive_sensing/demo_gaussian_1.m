close all; clearvars; clc;
rng('default');
% Length of each signal
N = 1000;
% The number of measurements
M = 100;

% The sensing matrix
Phi = spx.dict.simple.gaussian_mtx(M, N, false);

figure;
imagesc(Phi);
colorbar;

export_fig images/demo_gaussian_1.png -r120 -nocrop;


column_norms = spx.norm.norms_l2_cw(Phi);
figure;
hist(column_norms);
export_fig images/demo_gaussian_1_norm_hist.png -r120 -nocrop;


% singular values
singular_values = svd(Phi);
figure;
plot(singular_values);
ylim([0, 5]);
grid;
export_fig images/demo_gaussian_1_singular_values.png -r120 -nocrop;
