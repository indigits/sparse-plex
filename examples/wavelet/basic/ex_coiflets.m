close all; clear all; clc;

wave = SPX_Coiflet.wavelet_function(4, 8, 1024, 3);
subplot(221);
t = (1:1024)./1024;
plot(t(300:800),wave(300:800)); 
ylim([-.25 +.25]);
title(' C3 coiflet wavelet function ');


wave = SPX_Coiflet.scaling_function(4, 8, 1024, 3);
subplot(222);
t = (1:1024)./1024;
plot(t(300:800),wave(300:800)); 
ylim([-.25 +.25]);
title(' C3 coiflet scaling function ');
