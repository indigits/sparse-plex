A = eye(8);
x = [1 0 0 5 0 0 3 0]';
b = A * x;
K = 3;

result = spx.pursuit.fast_omp_chol(A, b, K, 1e-12);
cmpare = spx.commons.SparseSignalsComparison(x, result, K);
cmpare.summarize();
