% This script demonstrates how to use the frequency response function.

% Initialization
clear all; close all; clc;
% We prepare the Blackman filter.
% Number of signal samples
N = 10;
% FFT length
L = 1024;
% Blackman window coefficients
w = 0.42 - 0.5*cos(2*pi*(0:N-1)/N) + 0.08 * cos (4*pi*(0:N-1)/N);
% Alternatively w = blackman(N);
% Gain normalization
w = w / sum(w);
% Spectrum of Blackman window
Wf = fft(w, L);
f = (0:L-1)/L;
% Plot the filter
options.title = 'Blackman window';
options.ylabel = 'w(n)';
options.xstep = 1;
SPX_Plot.discrete_signal(w, options);
% Plot the frequency response of the Blackman window
options.decibels = true;
SPX_Plot.frequency_response(Wf, options);
