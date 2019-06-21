function spx_lansvd(A, k)
clc;
[m, n] = size(A);
fprintf('Running SPX fast LAN SVD with k=%d\n', k);
tstart = tic;
s = svds(A, k);
svds_time = toc(tstart);
fprintf('svds singular values: ');
spx.io.print.vector(s(1:k));
options.verbosity = 1;
options.p0 = ones(m, 1);
fprintf('p0 norm: %.4f\n', norm(options.p0));
if 1
    tstart = tic;
    %[U, S, V, details2] = spx.fast.lansvd(A, k, options);
    S = spx.fast.lansvd(A, k, options);
    lansvd_time = toc(tstart);
    fprintf('lansvd singular values: ');
    spx.io.print.vector(S);
    fprintf('SVDS time: %.4f sec, LANSVD time: %.4f sec', svds_time, lansvd_time);
    fprintf('  GAIN : %.2f X\n', svds_time / lansvd_time);

    if exist('details2')
        fprintf('Number of U reorthogonalizations: %d\n', details.nreorthu);
        fprintf('Number of V reorthogonalizations: %d\n', details.nreorthv);
        fprintf('Number of U inner products: %d\n', details.npu);
        fprintf('Number of V inner products: %d\n', details.npv);
    end
end

if 0
    fprintf('Original LANSVD\n')
    tstart = tic;
    S = lansvd(A, k, 'L', options);
    orig_lansvd_time = toc(tstart);
    fprintf('lansvd singular values: ');
    spx.io.print.vector(S);
    fprintf('SVDS time: %.4f sec, LANSVD time: %.4f sec', svds_time, orig_lansvd_time);
    fprintf('  GAIN : %.2f X\n', svds_time / orig_lansvd_time);
end

end
