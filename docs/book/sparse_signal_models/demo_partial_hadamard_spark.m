close all; clearvars; clc;
rng default;

PhiA = hadamard(20);
rows = randperm(20, 10);
Phi = PhiA(rows, :);

spx.norm.norms_l2_cw(Phi)

spx.dict.spark(Phi)
