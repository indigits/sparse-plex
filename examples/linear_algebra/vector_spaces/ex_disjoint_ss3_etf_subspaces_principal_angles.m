% In this example
% - We construct an ETF from a Steiner system
% - We choose specific vectors from the ETF to form three 3-dimensional subspaces
% - We verify that these subspaces are disjoint by measuring their combined rank.
% - We measure the principal angles between these subspaces
% - We verify that principal angle between each pair of subspaces is same.
% Construct an ETF
close all; clear all; clc;
% M = spx.discrete.steiner_system.ss_2(4);
M = spx.discrete.steiner_system.ss_3(15);
result = spx.dict.etf.ss_to_etf(M);
F = result.F;
fprintf('is etf : %d\n', spx.dict.etf.is_etf(F));
h_size = result.h_size;
fprintf('Size of F: ');
[m, n] = size(F);
fprintf('%d ', [m, n]);
d  = floor(result.r / 2);
% Choose the subspaces
indices = (0:d-1);
A = F(:, indices + 1)
B = F(:, indices + h_size + 1)
C = F(:, indices + 2*h_size + 1)
% Compute principal angles between the subspaces
fprintf('Ranks: [A B]: %d, [B C]: %d, [A C]: %d, [A B C]: %d', ...
    rank([A B]), rank([B C]), rank([A C]), rank([A B C]));
spx.la.spaces.smallest_angle_deg(A, B)
spx.la.spaces.smallest_angle_deg(A, C)
spx.la.spaces.smallest_angle_deg(B, C)



