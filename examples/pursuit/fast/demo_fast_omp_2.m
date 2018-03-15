m = 100;
n = 1000;
k = 12;
A = spx.dict.simple.gaussian_dict(m, n);
gen = spx.data.synthetic.SparseSignalGenerator(n, k);
% create a sparse vector
x =  gen.biGaussian();
b = A*x;
A  = double(A);
result = spx.pursuit.fast_omp_chol(A, b, k, 1e-12);
cmpare = spx.commons.SparseSignalsComparison(x, result, k);
cmpare.summarize();
