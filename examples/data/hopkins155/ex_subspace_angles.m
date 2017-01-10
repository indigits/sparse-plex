close all; clear all; clc;

% Create the directory for storing results
spx.fs.ensure_dir('bin');

h = spx.data.motion.Hopkins155;
% pre-load all examples
h.load_all_examples();
h.describe();
examples = h.get_2_3_motions();
ne = length(examples);
fprintf('Number of 2, 3 motions: %d\n', ne);
min_angles = zeros(1, ne);
max_angles = zeros(1, ne);
all_ranks = zeros(3, ne);
for i=1:ne
    fprintf('Example (%d): ', i);
    example = examples{i};
    fprintf('%s, %d motions, %d points, %d frames;', example.name, example.num_motions, example.num_points, example.num_frames);
    % The dataset
    X = example.X;
    % average norm
    norms1 = spx.norm.norms_l2_cw(X);
    fprintf('\n');
    %X = spx.la.affine.homogenize(X, 1);
    norms2 = spx.norm.norms_l2_cw(X);
    m1 = mean(norms1);
    m2 = mean(norms2);
    d = (m2 - m1) * 100 / m1 ;
    %fprintf('Mean norm: before: %0.2f, after: %0.2f, diff: %0.2f %%\n', m1, m2, d);
    % now compute the bases for 4 dimensional approximations
    % bases  = spx.la.svd.low_rank_bases(X, example.counts, 2);
    [bases, ranks]  = spx.la.svd.vidal_rank_bases(X, example.counts, 0.1);
    all_ranks(1:example.num_motions, i) = ranks;
    fprintf('Ranks: ');
    fprintf('%d ', ranks);
    fprintf('\n');
    % bases  = spx.la.spaces.bases(X, example.counts);
    angles = spx.la.spaces.smallest_angles_deg(bases);
    off_diag_angles = spx.commons.matrix.off_diag_upper_tri_elements(angles);
    off_diag_angles = sort(off_diag_angles);
    minimum_angle = min(off_diag_angles);
    maximum_angle = max(off_diag_angles);
    fprintf('Angles between subspaces (degrees): \n');
    disp(angles);
    % disp(off_diag_angles');
    % fprintf('Minimum angle: %.2f degrees\n\n', minimum_angle);
    % fprintf('Maximum angle: %.2f degrees\n\n', maximum_angle);
    fprintf('\n');
    min_angles(i) = minimum_angle;
    max_angles(i) = maximum_angle;
end
fprintf ('Minimum angle: %0.2f deg\n', min(min_angles));
fprintf ('Maximum angle: %0.2f deg\n', max(max_angles));
save ('bin/principal_angles','min_angles', 'max_angles', 'all_ranks');
