close all;
clearvars;
clc;
[LoD,HiD,LoR,HiR] = wfilters('db4');
subplot(221);
stem(LoD, '.'); title('Lowpass Decomposition');
subplot(222);
stem(LoR,'.'); title('Lowpass Reconstruction');
subplot(223);
stem(HiD,'.'); title('Highpass Decomposition');
subplot(224);
stem(HiR,'.'); title('Highpass Reconstruction');

export_fig images/db4_filters.png -r120 -nocrop;
