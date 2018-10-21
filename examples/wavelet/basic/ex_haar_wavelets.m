close all; clear all; clc;

wave = spx.wavelet.haar.wavelet_function(4, 8, 1024);
subplot(221);
t = (1:1024)./1024;
plot(t(300:800),wave(300:800)); 
title(' Haar Wavelet ');


wave = spx.wavelet.haar.scaling_function(4, 8, 1024);
subplot(222);
t = (1:1024)./1024;
plot(t(300:800),wave(300:800)); 
title(' Haar Scaling function ');
