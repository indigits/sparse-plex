clc;
close all;
clearvars;
n = 8;
% The binomial causes power method to oscillate
% A = gallery('binomial',n);
A = gallery('lotkin',n);
H = hess(A)
% The form keeps on repeating in oscillations
for i=1:10
    H = spx.la.hessenberg.qr_rq(H)
end

