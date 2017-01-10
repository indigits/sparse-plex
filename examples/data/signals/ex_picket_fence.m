% Demonstrates Picket Fence signal

% Initialization
clear all; close all; clc; 


N  = 256;

x = SPX_SimpleSignals.picket_fence(N);

fx = fft(x);

spx.graphics.figure.full_screen;
subplot(211);
stem(x, '.');
title('Time domain');
subplot(212);
stem(fx, '.');
title('Frequency domain');
