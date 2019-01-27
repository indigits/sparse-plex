close all;
clearvars;
clc;
rng default;
M = 2;
N = 4;
p = randperm(N);
% select some rows randomly
row_pics = sort(p(1:M));
% make sure that the first row is there
row_pics(1) = 1;
col_perm = randperm(N);
Dict = spx.dict.PartialDCT(row_pics, col_perm);

x = ones(N, 1)
y  = Dict.apply(x)
z = Dict.adjoint(y)

x(1) = x(1) + 2
y  = Dict.apply(x)
z = Dict.adjoint(y)

