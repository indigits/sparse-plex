close all; clear all; clc;
rng('default');
resize_images = true;

target.psnr = 35;
% target mean square error
target.mse = 255^2 * 10^(-target.psnr/10);
image_width = 42;
image_height = 48;
num_pixels = image_width * image_height;
% target sum of squared errors
target.sse = num_pixels * target.mse;
% target residual norm
target.rnorm = sqrt(target.sse);
fprintf('Target PSNR: %.2f dB\n', target.psnr);
fprintf('Target Mean Square Error: %.2f\n', target.mse);
fprintf('Target Root Mean Square Error: %.2f\n', sqrt(target.mse));
fprintf('Target Residual Norm: %.2f\n', target.rnorm);

N =  num_pixels;
redundancy_factor = 8;
D = redundancy_factor * N;

A = spx.dict.simple.gaussian_mtx(N, D);
dc_atom = (1/sqrt(N)) * ones(N, 1);
% throw away one original atom and replace with DC.
A = [dc_atom A(:, 1:D-1)];
dictionary = spx.dict.MatrixOperator(A);


yf = spx.data.image.YaleFaces();
yf.load();
fprintf('\n Resizing images:\n');
tstart = tic;
yf.resize_all(42, 48);
images = yf.ImageData;
[~, S] = size(images);
%images = yf.get_subject_images_resized(1, 42, 48);
elapsed = toc(tstart);
fprintf('Time taken: %.2f seconds \n', elapsed);
representations = zeros(D, S);
elapsed_times = zeros(1, S);
support_sizes = zeros(1, S);
res_norms = zeros(1, S);
psnrs = zeros(1, S);
fprintf('Total images: %d\n', S);
for s=1:S
    Y = images(:, s);
    solver = spx.pursuit.single.OrthogonalMatchingPursuit(dictionary);
    solver.MaxResNorm = target.rnorm;
    solver.Verbose = true;
    fprintf('sparsifying image: %d\n', s);
    tstart = tic;
    result = solver.solve_qr(Y);
    elapsed = toc(tstart);
    fprintf('Time taken: %.2f seconds \n', elapsed);
    fprintf('Support size: %d\n', result.iterations);
    support_sizes(s) = result.iterations;
    elapsed_times(s) = elapsed;
    representations(:, s) = result.z;
    res_norms(s) = result.rnorm;
    sse = result.rnorm^2;
    mse =  sse / num_pixels;
    psnr = 10 * log10(255^2 / mse);
    psnrs(s) = psnr;
    fprintf('PSNR : %.3f dB\n', psnr);
    if mod(s, 100) == 0
        % We wish to save intermediate data too
        save('omp_representations', 'representations');
        save('omp_stats', 'elapsed_times', 'support_sizes', 'res_norms', 'psnrs', 's');
    end
end
% final saving of all data.
save('bin/omp_dictionary', 'dictionary', 'N', 'D');
save('bin/omp_images', 'images');
save('bin/omp_representations', 'representations');
save('bin/omp_stats', 'elapsed_times', 'support_sizes', 'res_norms', 'psnrs', 'S');


