close all; clearvars; clc;
N = 256;
Phi = spx.dict.simple.dirac_dct_mtx(N);
figure;
imagesc(Phi);
colorbar;
export_fig images/demo_dirac_dct_1.png -r120 -nocrop;

mu1 = spx.dict.babel(Phi);
figure;
plot(mu1);
grid on;
export_fig images/demo_dirac_dct_babel.png -r120 -nocrop;


