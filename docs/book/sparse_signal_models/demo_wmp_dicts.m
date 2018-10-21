close all;
clearvars;
clc;

N  = 32;
Phi = wmpdictionary(N, 'lstcpt', {'RnIdent', 'dct'});
figure;
imagesc(Phi);
colorbar;

saveas(gcf, sprintf('images/wmp_dirac_dct_N_%d.png', N));

N = 256;
[Phi, nb_atoms] = wmpdictionary(N, 'lstcpt', { {'sym4', 5}, 'dct'});
figure;
imagesc(Phi);
colorbar;

saveas(gcf, sprintf('images/wmp_sym4_dct_N_%d.png', N));


N = 256;
[Phi, nb_atoms] = wmpdictionary(N, 'lstcpt', { {'sym4', 5}, {'wpsym4', 5}, 'dct'});
figure;
imagesc(Phi);
colorbar;

saveas(gcf, sprintf('images/wmp_sym4_wpsym4_dct_N_%d.png', N));

