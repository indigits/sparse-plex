% Solving a least squares problem using Householder QR factorization
m = 8;
n = 4;
A = gallery('binomial',m);
A = A(:, 1:n)
x0 = (1:n)'
b = A * x0

x = spx.opt.ls.house_ls(A, b)

