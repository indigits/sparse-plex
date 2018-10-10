close all; clearvars; clc;
rng default;

PhiA = hadamard(20);
rows = randperm(20, 10);
PhiB = PhiA(rows, :);

Phi = 1/sqrt(10) * PhiB;

spx.norm.norms_l2_cw(Phi)