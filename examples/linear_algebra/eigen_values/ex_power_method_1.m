clc;
close all;
clearvars;
% A = [1     1     1
%      1     2     3
%      1     3     6];
n = 10;
% A = hadamard(n);
% gaussian matrix would have complex eigen values.
% A = randn(n);
% A = magic(n);
% The binomial matrix causes oscillations in power method
% A = gallery('binomial',n);
A = gallery('lotkin',n);

[x, lambda, details] = spx.la.eig.power(A);

fprintf('Number of iterations: %d\n', details.iterations);
fprintf('Eigen value: %.4f\n', lambda);
fprintf('Eigen vector: ');
spx.io.print.vector(x, 4);
fprintf('A * x / lambda: ');
spx.io.print.vector(A*x / lambda, 4);

[x2, lambda2] = eigs(A, 1);

fprintf('Lambda mismatch: %.4f\n', abs(lambda - lambda2));
fprintf('Eig vec mismatch: %.4f\n', norm(abs(x) - abs(x2)));

if 0
    plot(details.lambdas);
    xlabel('Iterations');
    ylabel('\lambda');
end
