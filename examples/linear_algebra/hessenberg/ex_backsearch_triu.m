clc;
clearvars;
n = 8;
A = gallery('lotkin',n)
H = triu(A)
[H, i1 i2] = spx.la.hessenberg.backsearch(H)
H

