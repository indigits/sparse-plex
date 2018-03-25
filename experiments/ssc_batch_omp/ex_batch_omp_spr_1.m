
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
C = spx.pursuit.fast_batch_omp_spr(Y, K, 0)

Y * C
abs(Y - Y * C)

