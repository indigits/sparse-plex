clear all; close all; clc;
% Create the directory for storing results
spx.fs.ensure_dir('bin');
h = spx.data.motion.Hopkins155;
% pre-load all examples
h.load_all_examples();
examples = h.get_2_3_motions();
R = length(examples);
fprintf('Number of sequences: %d\n', R);

% 1 : 0.03
% 3 : 0.13
% 5 : 0.47
% 8 : 0.02
% 12 : 0.48
% 55 : 0.47
% 90 : 0.42
% 91 : failure due to NaN.
% 104 : failure due to NaN.

r = 3;
fprintf('Example (%d): ', r);
example = examples{r};
fprintf('%s, %d motions, %d points, %d frames;\n', example.name, example.num_motions, example.num_points, example.num_frames);
% Ambient space dimension
M = example.M;
% Number of subspaces
K = example.num_motions;
% maximum dimension for each subspace
D = 5;
Ss = example.counts;
% total number of points
S = sum(Ss);
X = example.X;
%% homogenize
%% X = spx.la.affine.homogenize(X);
% solve_a_local_problem = false;
% if solve_a_local_problem
%     s= 65;
%     all_cols = 1:S;
%     cols = all_cols ~= s; % S - 1 columns
%     A = X(:, cols);
%     x = X(:, s);
%     cvx_begin
%         cvx_precision high
%         variable y(S-1,1);
%         minimize( norm(y,1) );
%         subject to
%             norm(A * y  - x) <= 0.01;
%     cvx_end;
% end

% Solve the sparse subspace clustering problem
options.num_clusters = K;
% clustering_result = spx.cluster.subspace.ssc_l1_mahdi(X);
% All signals are expected to  have a D-sparse representation
ssc = spx.cluster.ssc.SSC_L1(X, D, K);
ssc.Affine = true;
ssc.NoiseFactor = 0.001;
clustering_result = ssc.solve();

cluster_labels = clustering_result.labels;
true_labels = example.labels;
% Time to compare the clustering
comparison_result = spx.cluster.clustering_error(cluster_labels, true_labels, example.num_motions);
comparison_results{r} = comparison_result;
fprintf('\n error: %0.2f  %%', comparison_result.error_perc);
fprintf('\n\n');
