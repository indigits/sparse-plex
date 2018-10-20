close all; clearvars; clc;
load mit200;
% Sampling frequency
fs = 360; 
periodogram(ecgsig, [], [], fs);
if 0
    figure;
    [pxx, f] = periodogram(ecgsig, [], [], fs);
    plot(f,10*log10(pxx));
    xlabel('Hz');
    grid on;
end