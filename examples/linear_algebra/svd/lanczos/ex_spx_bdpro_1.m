clc;
close all;
clearvars;

rng default;

A = mat_selector();

k  = 30;
spx_bdpro(A, k);