close all; clearvars; clc;
rng default;
N = 20;
M = 10;
K = 2;
PhiA = hadamard(N);
rows = randperm(N, M);
PhiB = PhiA(rows, :);
Phi = spx.norm.normalize_l2(PhiB);

rng(100);
gen = spx.data.synthetic.SparseSignalGenerator(N, K);
x =  gen.biGaussian();
y = Phi * x;
fprintf('The representation: ');
spx.io.print.sparse_signal(x);

z = zeros(N, 1);
r = y;
for i=1:100
    inner_products = Phi' * r;
    [max_abs_inner_product, index]  = max(abs(inner_products));
    max_inner_product = inner_products(index);
    z(index) = z(index) + max_inner_product;
    r = r - max_inner_product * Phi(:, index);
    norm_residual = norm(r);
    fprintf('[%d]: k: %d, h_k : %.4f, r_norm: %.4f, estimate: ', i, index, norm_residual, max_inner_product);
    spx.io.print.sparse_signal(z);
    if norm_residual < 1e-4
        break;
    end
end
