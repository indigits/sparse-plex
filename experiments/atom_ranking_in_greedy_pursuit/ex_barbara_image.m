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
K = 4;
support_intersection_ratios = zeros(1, num_tests);
for nt = 1:num_tests
    y = problem.patches(:, nt);

    % OMP solver instance
    solver = spx.pursuit.single.OrthogonalMatchingPursuit(problem.dictionary, K);
    % Solve the sparse recovery problem
    omp_result = solver.solve(y);
    z = omp_result.z;
    r = omp_result.r;
    y_hat = problem.dictionary * z;
    omp_support = spx.commons.sparse.support(z);
    if VERBOSE 
        fprintf('OMP   : Image norm:  %0.2f approximation norm:  %0.2f residual norm: %0.2f, SNR: %.2f dB\n', norm(y), norm(y_hat), norm(r), spx.commons.snr.recSNRdB(y, y_hat));
    end

    omp_ar_result = atom_ranked_omp(problem.dictionary, y, K);
    z = omp_ar_result.z;
    r = omp_ar_result.r;
    y_hat = problem.dictionary * z;
    omp_ar_support = spx.commons.sparse.support(z);
    common = intersect(omp_support, omp_ar_support);
    support_intersection_ratio = length(common) / K;
    support_intersection_ratios(nt) = support_intersection_ratio;
    if VERBOSE
        fprintf('OMP-AR: Image norm:  %0.2f approximation norm:  %0.2f residual norm: %0.2f, SNR: %.2f dB\n', norm(y), norm(y_hat), norm(r), spx.commons.snr.recSNRdB(y, y_hat));
    end
    fprintf('.');
    if mod(nt, 50) == 0
        fprintf('\n');
    end
end
failed_cases = sum(support_intersection_ratios < 1);
fprintf('Failed: %d, All : %d\n', failed_cases, num_tests);


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

