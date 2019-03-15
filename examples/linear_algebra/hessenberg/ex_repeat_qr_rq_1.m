clc;
close all;
clearvars;
n = 4;
A = gallery('binomial',n);
H = hess(A)
% The form keeps on repeating in oscillations
for i=1:100
    H = spx.la.hessenberg.qr_rq(H)
end

