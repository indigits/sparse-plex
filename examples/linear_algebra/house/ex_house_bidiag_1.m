clc;
close all;
clearvars;

n = 8;
A = gallery('binomial',n)
[UF, B, VF] = spx.la.house.bidiag(A)
U = spx.la.house.q_back_accum_thin(UF)
V = spx.la.house.q_back_accum_thin(VF)
A1 = U * B * V'
fprintf('Max Diff ::: %f\n', max(max(abs(A-A1))));


