%clc;
close all;
clearvars;
cd I:\work\projects\sparse-plex\library\+spx\+fast\private;
make mex_lansvd.cpp;
cd I:\work\projects\sparse-plex\examples\linear_algebra\svd\lanczos;
A = spx.data.mtx_mkt.illc1850;
k = 20;
trials  = 50;
fprintf('Running SPX fast LAN SVD with k=%d\n', k);
tstart = tic;
for i=1:trials
s = svds(A, k);
end
svds_time = toc(tstart);
fprintf('svds singular values: ');
spx.io.print.vector(s(1:k));
options.verbosity = 0;
options.k = k;
% options.max_iters = 80;
tstart = tic;
for i=1:trials
[U, S, V, details] = spx.fast.lansvd(A, options);
end
lansvd_time = toc(tstart);
fprintf('lansvd singular values: ');
spx.io.print.vector(S);
fprintf('SVDS time: %.4f sec, LANSVD time: %.4f sec', svds_time, lansvd_time);
fprintf('  GAIN : %.2f X\n', svds_time / lansvd_time);
fprintf('k_done: %d, converged: %d\n', details.k_done, details.converged);
