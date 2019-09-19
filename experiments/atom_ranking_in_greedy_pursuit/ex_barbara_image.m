% Initialize
clear all; close all; clc; 
VERBOSE = false;
problem.image = spx.data.standard_images.barbara_gray_512x512;
% Block size
problem.blk_size = 8;
% Number of atoms in dictionary
problem.D = 121;
% Signal dimension
problem.N = problem.blk_size * problem.blk_size;
% Let us create all the patches from image
problem.patches = im2col(problem.image, [problem.blk_size, problem.blk_size], 'distinct');
% Let us construct a 1D-DCT matrix of size 8x11.
dr = sqrt(problem.D);
DCT=zeros(problem.blk_size, dr);
for k=0:1:dr-1,
    is = 0:1:problem.blk_size-1;
    % Create one column
    col=cos(is'*k*pi/dr);
    if k>0
        col=col-mean(col); 
    end;
    DCT(:,k+1)=col/norm(col);
end;
% We create our initial dictionary as a 64x121 size
problem.dictionary = kron(DCT, DCT);
problem.DCT = DCT;

% number of patches to test
num_patches = size(problem.patches, 2);
num_tests = num_patches;
K = 8;
support_intersection_ratios = zeros(1, num_tests);
omp_time =0;
omp_ar_time = 0;
barbara_omp = zeros(size(problem.patches));
barbara_omp_ar = zeros(size(problem.patches));
for nt = 1:num_tests
    y = problem.patches(:, nt);

    tstart = tic;
    % OMP solver instance
    % solver = spx.pursuit.single.OrthogonalMatchingPursuit(problem.dictionary, K);
    % % Solve the sparse recovery problem
    % omp_result = solver.solve(y);
    % z = omp_result.z;
    % r = omp_result.r;
    options = struct;
    z = spx.fast.omp(problem.dictionary, y, K, 1e-3, options);
    omp_time = omp_time + toc(tstart);
    y_hat = problem.dictionary * z;
    r = y - y_hat;
    omp_support = spx.commons.sparse.support(z);
    if VERBOSE 
        fprintf('OMP   : Image norm:  %0.2f approximation norm:  %0.2f residual norm: %0.2f, SNR: %.2f dB\n', norm(y), norm(y_hat), norm(r), spx.snr.recSNRdB(y, y_hat));
    end
    barbara_omp(:, nt) = y_hat;
    tstart = tic;
    z = fast_omp_ar_solver(problem.dictionary, K, y);
    % omp_ar_result = atom_ranked_omp(problem.dictionary, y, K);
    % z = omp_ar_result.z;
    % r = omp_ar_result.r;
    omp_ar_time = omp_ar_time + toc(tstart);
    y_hat = problem.dictionary * z;
    r = y - y_hat;
    omp_ar_support = spx.commons.sparse.support(z);
    barbara_omp_ar(:, nt) = y_hat;
    if VERBOSE
        fprintf('OMP-AR: Image norm:  %0.2f approximation norm:  %0.2f residual norm: %0.2f, SNR: %.2f dB\n', norm(y), norm(y_hat), norm(r), spx.snr.recSNRdB(y, y_hat));
    end
    % Analyze the differences in sparse representation
    common = intersect(omp_support, omp_ar_support);
    support_intersection_ratio = length(common) / K;
    support_intersection_ratios(nt) = support_intersection_ratio;
    fprintf('.');
    if mod(nt, 50) == 0
        fprintf('\n');
    end
end
t1 = omp_time;
t2 = omp_ar_time;
gain_x = t1/t2;
if t1 > t2
    gain_perc = (t1 - t2) * 100/ t1;
else
    gain_perc = (t1 - t2) * 100/ t2;
end
failed_cases = sum(support_intersection_ratios < 1);
fprintf('\nFailed: %d, All : %d\n', failed_cases, num_tests);
fprintf('Time: OMP: %.2f seconds, OMP-AR: %.2f seconds\n', omp_time, omp_ar_time);
fprintf('Gain: %.2f (%.1f %%)\n', gain_x, gain_perc);

barbara_omp = col2im(barbara_omp, [problem.blk_size, problem.blk_size], size(problem.image) , 'distinct');
barbara_omp_ar = col2im(barbara_omp_ar, [problem.blk_size, problem.blk_size], size(problem.image) , 'distinct');
omp_psnr = psnr(barbara_omp,  problem.image,255);
omp_ar_psnr = psnr(barbara_omp_ar,  problem.image,255);
fprintf('K: %d, PSNR : OMP : %.2f dB, OMP-AR: %.2f dB\n', K, omp_psnr, omp_ar_psnr);

barbara = uint8(problem.image);
barbara_omp = uint8(barbara_omp);
barbara_omp_ar = uint8(barbara_omp_ar);

imwrite(barbara, 'bin/barbara.jpg');
imwrite(barbara_omp, sprintf('bin/barbara_omp_K=%d.jpg', K));
imwrite(barbara_omp_ar, sprintf('bin/barbara_omp_ar_K=%d.jpg', K));

if 0
mf = spx.graphics.Figures();
mf.new_figure('OMP solution');
subplot(311);
stem(result.z, '.');
title('Recovered sparse representation');
subplot(312);
stem(result.r, '.');
title('Approximation error');
subplot(313);
stem(patch, '.');
title('Image vector');
end

