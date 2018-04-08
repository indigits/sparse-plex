import spx.cluster.ssc.OMP_REPR_METHOD;
import spx.cluster.ssc.SSC_OMP;


method = OMP_REPR_METHOD.CLASSIC_OMP_C;
method = OMP_REPR_METHOD.FLIPPED_OMP_MATLAB;
method = OMP_REPR_METHOD.BATCH_FLIPPED_OMP_MATLAB;
method = OMP_REPR_METHOD.BATCH_FLIPPED_OMP_C;
method = OMP_REPR_METHOD.BATCH_OMP_C;

% maximum dimension for each subspace
D = 10;
% Number of dimensions to which the digits data should be
% approximated.
pca_dim = 500;
% preparation of dataset
digit_set = 0:9;
% Number of subspaces
K = length(digit_set);
rnorm_thr  = 1e-3;
if ~exist('md')
    fprintf('MNIST dataset has not been loaded.\n');
    md = spx.data.image.ChongMNISTDigits;
end
num_samples_per_digit = 50;
cluster_sizes = num_samples_per_digit*ones(1, K);
% total number of samples
S = sum(cluster_sizes);
% identify sample indices for each digit
sample_list = [];
for k=1:K
    digit = digit_set(k);
    digit_indices = md.digit_indices(digit);
    num_digit_samples = length(digit_indices);
    % initialize the random number generator for repeatability
    rng(k);
    choices = randperm(num_digit_samples, cluster_sizes(k));
    selected_indices = digit_indices(choices);
    sample_list = [sample_list selected_indices];
end
[Y, true_labels] = md.selected_samples(sample_list);
% Perform PCA to reduce dimensionality
Y = spx.la.pca.low_rank_approx(Y, pca_dim);
%% Perform SSC-OMP using first method.
rng default; 
tstart = tic; 
solver = SSC_OMP(Y, D, K, rnorm_thr, method);
result = solver.solve();
total = toc(tstart);
fprintf('time: %.2f seconds\n', total);
labels = result.Labels;
% time to compute representations
repr = result.representation_time;
%% Time to compare the clustering
comparer = spx.cluster.ClusterComparison(true_labels+1, labels);
comparison_result = comparer.fMeasure();
comparer.printF1MeasureResult(comparison_result);
