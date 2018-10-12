
close all;
clearvars;
clc;
[LoD,HiD,LoR,HiR] = wfilters('db4');

figure;
load noisdopp;
plot(noisdopp);
export_fig images/noisdopp.png -r120 -nocrop;

% perform decomposition
[approximation, detail] = dwt(noisdopp,LoD,HiD);

% plot approximation and detail components
figure;
subplot(211);
plot(approximation); title('Approximation');
subplot(212);
plot(detail); title('Detail');

export_fig images/noisdoop_db4_decomposition.png -r120 -nocrop;


reconstructed = idwt(approximation, detail,LoR,HiR);

% measure the maximum difference
max_abs_diff = max(abs(noisdopp-reconstructed))
