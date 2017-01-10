
% Initialization
clear all; close all; clc; 
gen = spx.data.synthetic.MultiToneSignalGenerator();
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
plot(t, x);
