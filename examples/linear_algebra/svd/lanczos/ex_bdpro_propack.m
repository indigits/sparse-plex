clc;
close all;
clearvars;

rng default;
A = mat_selector();
k = 30;
propack_lanbdpro(A, k);
