% Create the directory for storing results
spx.fs.ensure_dir('bin');
close all;
clc;

import spx.cluster.ssc.OMP_REPR_METHOD;
import spx.cluster.ssc.SSC_OMP;


% STP.method1 = OMP_REPR_METHOD.FLIPPED_OMP_MATLAB;
% STP.method2 = OMP_REPR_METHOD.BATCH_FLIPPED_OMP_MATLAB;

STP.method1 = OMP_REPR_METHOD.CLASSIC_OMP_C;
STP.method2 = OMP_REPR_METHOD.BATCH_FLIPPED_OMP_C;

STP.method1 = OMP_REPR_METHOD.BATCH_OMP_C;
STP.method2 = OMP_REPR_METHOD.BATCH_FLIPPED_OMP_C;

% STP.method1 = OMP_REPR_METHOD.FLIPPED_OMP_MATLAB;
% STP.method2 = OMP_REPR_METHOD.BATCH_FLIPPED_OMP_C;

STP.method1 = OMP_REPR_METHOD.CLASSIC_OMP_C;
STP.method2 = OMP_REPR_METHOD.BATCH_OMP_C;

STP.method1 = OMP_REPR_METHOD.FLIPPED_OMP_MATLAB;
STP.method2 = OMP_REPR_METHOD.BATCH_OMP_C;


% Experiment configuration
STP.num_samples_per_digit_arr = [50 80 100 150 200 300 400 600];
STP.num_samples_per_digit_arr = [50 80 100 150 200];

% maximum dimension for each subspace
STP.D = 10;
% Number of dimensions to which the digits data should be
% approximated.
STP.pca_dim = 500;
% preparation of dataset
STP.digit_set = 0:9;
% Number of subspaces
STP.K = length(STP.digit_set);
STP.rnorm_thr  = 1e-3;

if ~exist('md')
    fprintf('MNIST dataset has not been loaded.\n');
    md = spx.data.image.ChongMNISTDigits;
end


nns = numel(STP.num_samples_per_digit_arr);
% number of trials
STP.num_trials_per_setup = 4;
STP.num_trials = STP.num_trials_per_setup * nns;

% Arrays to capture experimental results
num_samples_per_digit = zeros(STP.num_trials, 1);
m1_total = zeros(STP.num_trials, 1);
m1_repr = zeros(STP.num_trials, 1);
m2_total = zeros(STP.num_trials, 1);
m2_repr = zeros(STP.num_trials, 1);

trial_num = 0;
for ns=1:nns
for nt = 1:STP.num_trials_per_setup
    trial_num  = trial_num + 1;
    q.num_samples_per_digit = STP.num_samples_per_digit_arr(ns);
    fprintf('Trial for %d samples per digit\n', q.num_samples_per_digit);
    q.cluster_sizes = q.num_samples_per_digit*ones(1, STP.K);
    % total number of samples
    q.S = sum(q.cluster_sizes);
    % identify sample indices for each digit
    q.sample_list = [];
    for k=1:STP.K
        q.digit = STP.digit_set(k);
        q.digit_indices = md.digit_indices(q.digit);
        q.num_digit_samples = length(q.digit_indices);
        % initialize the random number generator for repeatability
        rng(k);
        q.choices = randperm(q.num_digit_samples, q.cluster_sizes(k));
        q.selected_indices = q.digit_indices(q.choices);
        q.sample_list = [q.sample_list q.selected_indices];
    end
    [q.Y, q.true_labels] = md.selected_samples(q.sample_list);
    % Perform PCA to reduce dimensionality
    q.Y = spx.la.pca.low_rank_approx(q.Y, STP.pca_dim);


    %% Perform SSC-OMP using first method.
    rng default; 
    tstart = tic; 
    m1_solver = SSC_OMP(q.Y, STP.D, STP.K, STP.rnorm_thr, STP.method1);
    m1_result = m1_solver.solve();
    q.m1_total = toc(tstart);
    fprintf('M1 time: %.2f seconds', q.m1_total);
    m1_labels = m1_result.Labels;
    % time to compute representations
    q.m1_repr = m1_result.representation_time;

    %% Perform SSC-OMP using second method.
    rng default; 
    tstart = tic;
    m2_solver = SSC_OMP(q.Y, STP.D, STP.K, STP.rnorm_thr, STP.method2);
    m2_result = m2_solver.solve();
    q.m2_total = toc(tstart);
    fprintf('M2 time: %.2f seconds\n', q.m2_total);
    m2_labels = m2_result.Labels;
    % time to compute representations.
    q.m2_repr = m2_result.representation_time;


    %% Time to compare the clustering
    q.comparer = spx.cluster.ClusterComparison(m1_labels, m2_labels);
    q.comparison_result = q.comparer.fMeasure();
    q.comparer.printF1MeasureResult(q.comparison_result);

    % capture experimental data
    num_samples_per_digit(trial_num) = q.num_samples_per_digit;
    m1_total(trial_num) = q.m1_total;
    m1_repr(trial_num) = q.m1_repr;
    m2_total(trial_num) = q.m2_total;
    m2_repr(trial_num) = q.m2_repr;
    fprintf('----REPR GAIN---- : %.2f\n', q.m1_repr / q.m2_repr)

    % destroy variables not required
    clear m1_solver m2_solver m1_result m2_result m1_labels m2_labels;
end
end
% get rid of unnecessary variables.
clear q k ns;
clear nns nt tstart trial_num;
% Convert the experimental data into a table
RSLT = table(num_samples_per_digit, m1_total, ...
    m1_repr, m2_total, ...
    m2_repr);
clear num_samples_per_digit m1_total m1_repr  m2_total m2_repr;
save('bin/mnist_speed_test.mat', 'RSLT', 'STP');

