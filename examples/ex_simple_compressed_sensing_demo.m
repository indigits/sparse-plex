close all;
clear all;
clc;
rng('default');
png_export = true;
pdf_export = false;
% Create the directory for storing images
[status_code,message,message_id] = mkdir('bin');

mf = spx.graphics.Figures();

% Signal space 
N = 256;
% Number of measurements
M = 64;
% Sparsity level
K = 4;

% Constructing a sparse vector
% Choosing the support randomly
Omega = randperm(N, K);
% Initializing a zero vector
x = zeros(N, 1);
if 0
% Filling it with non-zero Gaussian entries at specified support
x(Omega) = 4 * randn(K, 1);
mf.new_figure('Gaussian sparse signal');
stem(x, '.');
xlabel('Index');
ylabel('Value');
title('Sparse vector');
if png_export
export_fig bin\k_sparse_gaussian_signal.png -r120 -nocrop;
end
if pdf_export
export_fig bin\k_sparse_gaussian_signal.pdf;
end
end

% Choosing non-zero values uniformly between (-b, -a) and (a, b)
a = 1;
b = 2; 
% unsigned magnitudes of non-zero entries
xm = a + (b-a).*rand(K, 1);
% Generate sign for non-zero entries randomly
sgn = sign(randn(K, 1));
% Combine sign and magnitude
x(Omega) = sgn .* xm;
mf.new_figure('Bi-uniform sparse signal');
stem(x, '.');
xlabel('Index');
ylabel('Value');
title('Sparse vector');
if png_export
export_fig bin\k_sparse_biuniform_signal.png -r120 -nocrop;
end
if pdf_export
export_fig bin\k_sparse_biuniform_signal.pdf;
end

% Identifying support
find(x ~= 0)'

% 98   127   277   544   630   815   905   911


% Constructing a Gaussian sensing matrix
Phi = randn(M, N);
% Make sure that variance is 1/sqrt(M)
Phi = Phi ./ sqrt(M);

% Computing norm of each column
column_norms = sqrt(sum(Phi .* conj(Phi)));

% Let us plot the histogram of norms of each column vector in Phi.
mf.new_figure('Norm histogram');
hist(spx.norm.norms_l2_cw(Phi), 20);
xlabel('Norm');
ylabel('Count');
if png_export
export_fig bin\guassian_sensing_matrix_histogram.png -r120 -nocrop;
end
if pdf_export
export_fig bin\guassian_sensing_matrix_histogram.pdf;
end

% Constructing a Gaussian dictionary with normalized columns
for i=1:N
    v = column_norms(i);
    % Scale it down
    Phi(:, i) = Phi(:, i) / v;
end
% Normalized dictionary
Phi = spx.norm.normalize_l2(Phi);

% Visualizing the sensing matrix
mf.new_figure('Sensing matrix');
imagesc(Phi) ;
colormap(gray);
colorbar;
axis image;
title('\Phi');
if png_export
export_fig bin\gaussian_matrix.png -r120 -nocrop;
end
if pdf_export
export_fig bin\gaussian_matrix.pdf;
end


% Making random measurements
mf.new_figure('Measurement vector');
y0 = Phi * x;
stem(y0, '.');
xlabel('Index');
ylabel('Value');
title('Measurement vector');
if png_export
export_fig bin\measurement_vector_biuniform.png -r120 -nocrop;
end
if pdf_export
export_fig bin\measurement_vector_biuniform.pdf;
end

% Adding some measurement noise.
SNR = 15;

snr = db2pow(SNR);
noise = randn(M, 1);
% we treat each column as a separate data vector
signalNorm = norm(y0);
noiseNorm = norm(noise);
actualNormRatio = signalNorm / noiseNorm;
requiredNormRatio = sqrt(snr);
gain_factor = actualNormRatio  / requiredNormRatio;
noise = gain_factor .* noise;


% Creating noise using helper function
e = spx.data.noise.Basic.createNoise(y0, SNR);
% Measurement vector with noise.
y = y0 + e;
mf.new_figure('Measurement vector with noise');
stem(y, '.');
xlabel('Index');
ylabel('Value');
title(sprintf('Measurement vector with noise at SNR=%d dB', SNR));
if png_export
export_fig bin\measurement_vector_biuniform_noisy.png -r120 -nocrop;
end
if pdf_export
export_fig bin\measurement_vector_biuniform_noisy.pdf;
end


% Matching pursuit
solver = spx.pursuit.single.MatchingPursuit(Phi, K);
result = solver.solve(y);
mf.new_figure('Matching pursuit solution');
mp_solution = result.z;
subplot(211);
stem(mp_solution, '.');
xlabel('Index');
ylabel('Value');
title('Matching pursuit solution');
mp_diff = x - mp_solution;
subplot(212);
stem(mp_diff, '.');
xlabel('Index');
ylabel('Value');
title('Matching pursuit recovery error');
if png_export
export_fig bin\cs_matching_pursuit_solution.png -r120 -nocrop;
end
if pdf_export
export_fig bin\cs_matching_pursuit_solution.pdf;
end

% Recovery error
mp_recovery_error = norm(mp_diff) / norm(x);
fprintf('Matching pursuit recovery error: %0.4f\n', mp_recovery_error);


% Orthogonal Matching pursuit
solver = spx.pursuit.single.OrthogonalMatchingPursuit(Phi, K);
result = solver.solve(y);
mf.new_figure('Orthogonal Matching pursuit solution');
omp_solution = result.z;
subplot(211);
stem(omp_solution, '.');
xlabel('Index');
ylabel('Value');
title('Orthogonal Matching pursuit solution');
omp_diff = x - omp_solution;
subplot(212);
stem(omp_diff, '.');
xlabel('Index');
ylabel('Value');
title('Orthogonal Matching pursuit recovery error');
if png_export
export_fig bin\cs_orthogonal_matching_pursuit_solution.png -r120 -nocrop;
end
if pdf_export
export_fig bin\cs_orthogonal_matching_pursuit_solution.pdf;
end

% Recovery error
omp_recovery_error = norm(omp_diff) / norm(x);
fprintf('Orthogonal Matching pursuit recovery error: %0.4f\n', omp_recovery_error);


% Basis pursuit
solver = spx.pursuit.single.BasisPursuit(Phi, y);
result = solver.solve_l1_noise();
mf.new_figure('l_1 minimization solution');
l1_solution = result;
subplot(211);
stem(l1_solution, '.');
xlabel('Index');
ylabel('Value');
title('l_1 minimization solution');
l1_diff = x - l1_solution;
subplot(212);
stem(l1_diff, '.');
xlabel('Index');
ylabel('Value');
title('l_1 minimization recovery error');
if png_export
export_fig bin\cs_l_1_minimization_solution.png -r120 -nocrop;
end
if pdf_export
export_fig bin\cs_l_1_minimization_solution.pdf;
end

% Recovery error
l1_recovery_error = norm(l1_diff) / norm(x);
fprintf('l_1 recovery error: %0.4f\n', l1_recovery_error);
