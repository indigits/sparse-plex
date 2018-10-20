close all; clearvars; clc;
load mit200;
% Sampling frequency
fs = 360; 
spectrogram(ecgsig, [], [], [], fs);
