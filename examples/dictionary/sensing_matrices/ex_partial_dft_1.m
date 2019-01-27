close all;
clearvars;
clc;
rng default;
M = 8;
N = 16;
p = randperm(N);
% select some rows randomly
row_pics = sort(p(1:M));
% make sure that the first row is there
row_pics(1) = 1;
col_perm = randperm(N);
%col_perm = 1:N;
Dict = spx.dict.PartialDFT(row_pics, col_perm);
x = ones(N, 1)
y  = Dict.apply(x)
z = Dict.adjoint(y)

x(1) = x(1) + 2
y  = Dict.apply(x)
z = Dict.adjoint(y)

DictMtx = double(Dict);
B = dftmtx(N) / sqrt(N);
row_pics
DictMtx(:, 1:4)
B(:, 1:4)

