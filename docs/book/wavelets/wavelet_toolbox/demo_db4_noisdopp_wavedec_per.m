
close all;
clearvars;
clc;
[LoD,HiD,LoR,HiR] = wfilters('db4');

load noisdopp;

% change the DWT mode to periodization.
old_dwt_mode = dwtmode('status','nodisp');
dwtmode('per');
% perform 4 level decomposition
[coefficients, levels] = wavedec(noisdopp,4, LoD,HiD);

% plot approximation and detail components
figure;
plot(coefficients); title('Coefficients');

export_fig images/noisdopp_db4_l4_decomposition_per.png -r120 -nocrop;

% reconstruct the signal
reconstructed = waverec(coefficients, levels, LoR, HiR);

% measure the maximum difference
max_abs_diff = max(abs(noisdopp-reconstructed))


figure;
for level=0:4
    level_app_coeffs = appcoef(coefficients, levels, LoR, HiR, level);
    subplot(511+level);
    plot(level_app_coeffs);
    fprintf('%d ', numel(level_app_coeffs));
    title(sprintf('Approximation coefficients @ level-%d', level));
end

% restore the old DWT mode
dwtmode(old_dwt_mode);

export_fig images/noisdopp_db4_l4_appcoeffs_per.png -r120 -nocrop;
