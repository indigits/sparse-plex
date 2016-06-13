% Initialization
clear all; close all; clc; 
gen = SPX_MultiToneSignalGenerator();
gen.TotalDuration = 0.35;
% Sampling frequency
gen.SamplingFrequency = 1000;
% Frequencies (Hz)
gen.Frequencies = [113 247 327 413];
% Each frequency will be present in a segment of the
% overall signal duration.
% The segment is described by its origin and its duration.
gen.Origins = [0 0 0.030 0.150];
gen.Durations = [0.350 0.050 0.200 0.200];
% Amplitudes for each frequency
gen.Amplitudes = [1 1.7 1.9 1.8];

[x , t] = gen.run();
% Block length
B = 64;
% Overlapped samples length
O = 48;
% Length of FFT 
L  = 1024;
% Frequencies
freq = [0:L-1]/L;
solver = SPX_ShortTermFourierTransform(B, O, L, 'hamming');
[spectrum, timePoints] = solver.run(x);
% We preserve only one half of the frequencies
spectrum = abs(spectrum);
spectrum = spectrum(1:L/2, :);
spx.graphics.Figures.full_screen_figure;
imagesc(timePoints/gen.SamplingFrequency, ...
    freq(1:L/2) * gen.SamplingFrequency, spectrum);
title('STFT');
