clc;
clearvars;
n = 8;
A = gallery('lotkin',n)
H = hess(A)
H(n,n-1) = 1e-16;
%H(n-1,n-2) = 1e-16;
H(n-2,n-3) = 1e-16;
[H, i1 i2] = spx.la.hessenberg.backsearch(H)
H

