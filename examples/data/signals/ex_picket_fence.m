% Demonstrates Picket Fence signal

% Initialization
clear all; close all; clc; 


N  = 256;

x = SPX_Signals.picket_fence(N);

fx = fft(x);

SPX_Figures.full_screen_figure;
subplot(211);
stem(x, '.');
title('Time domain');
subplot(212);
stem(fx, '.');
title('Frequency domain');
