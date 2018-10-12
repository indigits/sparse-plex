
close all;
clearvars;
clc;
[LoD,HiD,LoR,HiR] = wfilters('db4');

load noisdopp;
% perform decomposition
coefficients = swt(noisdopp, 4, LoD,HiD);

% plot approximation and detail components
figure;
for level=0:4
    subplot(511+level);
    plot(coefficients(level+1, :)); 
    title(sprintf('SWT Coefficients @level-%d', level));
end

export_fig images/noisdoop_db4_l4_swt.png -r120 -nocrop;


reconstructed = iswt(coefficients,LoR,HiR);

% measure the maximum difference
max_abs_diff = max(abs(noisdopp-reconstructed))
