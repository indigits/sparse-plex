clc;
close all;
clearvars;
% A = [1     1     1
%      1     2     3
%      1     3     6];
% A = hadamard(20);
% gaussian matrix would have complex eigen values.
% A = randn(20);
A = magic(20);
[x, lambda, details] = spx.la.eig.power(A);

fprintf('Number of iterations: %d\n', details.iterations);
fprintf('Eigen value: %.4f\n', lambda);
fprintf('Eigen vector: ');
spx.io.print.vector(x, 4);
fprintf('A * x / lambda: ');
spx.io.print.vector(A*x / lambda, 4);
plot(details.lambdas);
xlabel('Iterations');
ylabel('\lambda');

