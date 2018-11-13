M = 5;
S1 = 4;
S2 = 4;
S = S1 + S2;
K = 2;
Y = zeros(M, S);
Y(1, 1:4) = [1 2 3 4];
Y(2, 1:4) = [3 3 2 6];
Y(3, 5:8) = [3 3 6 6];
Y(4, 5:8) = [4 5 6 7];
Y
Y = spx.norm.normalize_l2(Y)
C1 = spx.fast.omp_spr(Y, K, 0);
max(max(abs(Y - Y * C1)))

C2 = OMP_mat_func(Y, K, 0);
max(max(abs(Y - Y * C2)))
fprintf('Comparing C1 & C2: %e\n', full(max(max(abs(C1 - C2)))));

C3 = spx.fast.batch_flipped_omp_spr(Y, K, 0);
max(max(abs(Y - Y * C3)))
fprintf('Comparing C2 & C3: %e\n', full(max(max(abs(C2 - C3)))));
