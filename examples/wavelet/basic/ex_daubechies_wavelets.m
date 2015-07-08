close all; clear all; clc;

wave = SPX_DaubechiesWavelet.wavelet_function(4, 8, 1024, 4);
subplot(221);
t = (1:1024)./1024;
plot(t(300:800),wave(300:800)); 
ylim([-.25 +.25]);
title(' D4 Wavelet ');


wave = SPX_DaubechiesWavelet.scaling_function(4, 8, 1024, 4);
subplot(222);
t = (1:1024)./1024;
plot(t(300:800),wave(300:800)); 
ylim([-.25 +.25]);
title(' D4 Scaling function ');
