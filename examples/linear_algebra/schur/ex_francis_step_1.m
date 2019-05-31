clc;
clearvars;
n = 8;
A = gallery('lotkin',n)
H0 = triu(A, -1)
[H1, Z] = spx.la.schur.francis_step(H0)
% for i=1:4
%     H = spx.la.schur.francis_step(H)
%     H(n, n-1)
% end

HD = H0 - Z * H1 * Z'
max(max(abs(HD)))
