m = 100;
n = 1000;
k = 12;
A = spx.dict.simple.gaussian_dict(m, n);
gen = spx.data.synthetic.SparseSignalGenerator(n, k);
% create a sparse vector
x =  gen.biGaussian();
b = A*x;
A  = double(A);
result = spx.fast.omp(A, b, k, 1e-12);
cmpare = spx.commons.SparseSignalsComparison(x, result, k);
cmpare.summarize();

% we now run both algorithms 100 times
tic;
for i=1:1000
    result = spx.fast.omp(A, b, k, 1e-12);
end
elapsed_time1 = toc;
fprintf('Time taken %0.4f seconds\n', elapsed_time1);

tic;
for i=1:1000
    result = spx.pursuit.single.omp_chol(A, b, k, 1e-12);
end
elapsed_time2 = toc;
fprintf('Time taken %0.4f seconds\n', elapsed_time2);

improvement_factor = elapsed_time2 / elapsed_time1;
fprintf('improvement_factor: %0.2f \n', improvement_factor);

