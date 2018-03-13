rng default;
% Signal space 
N = 256;
% Number of measurements
M = 64;
% Sparsity level
K = 10;
% Construct the signal generator.
gen  = spx.data.synthetic.SparseSignalGenerator(N, K);
% Generate bi-uniform signals
x = gen.biUniform(1, 2);
% Sensing matrix
Phi = spx.dict.simple.gaussian_dict(M, N);
% Measurement vectors
y = Phi.apply(x);
% OMP MMV solver instance
result = spx.pursuit.single.omp_chol(double(Phi), y, K, 1e-6);
% Solution vector
z = result.z;

stats = spx.commons.sparse.recovery_performance(Phi, K, y, x, z);
spx.commons.sparse.print_recovery_performance(stats);

mf = spx.graphics.Figures();
mf.new_figure('OMP solution');
subplot(411);
stem(x, '.');
title('Sparse vector');
subplot(412);
stem(z, '.');
title('Recovered sparse vector');
subplot(413);
stem(abs(x - z), '.');
title('Recovery error');
subplot(414);
stem(y, '.');
title('Measurement vector');
