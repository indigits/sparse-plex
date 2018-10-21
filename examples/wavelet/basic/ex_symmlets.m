close all; clear all; clc;

wave = spx.wavelet.symm.wavelet_function(4, 8, 1024, 8);
subplot(221);
t = (1:1024)./1024;
plot(t(300:800),wave(300:800)); 
ylim([-.25 +.25]);
title(' S8 symmlet wavelet function ');


wave = spx.wavelet.symm.scaling_function(4, 8, 1024, 8);
subplot(222);
t = (1:1024)./1024;
plot(t(300:800),wave(300:800)); 
ylim([-.25 +.25]);
title(' S8 symmlet scaling function ');
