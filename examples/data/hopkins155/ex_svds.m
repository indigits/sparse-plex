close all; clear all; clc;
% Create the directory for storing results
spx.fs.ensure_dir('bin');

h = spx.data.motion.Hopkins155;
ne = h.num_examples;
fprintf('Number of sequences: %d\n', ne);

motion3 = 0;
motion2 = 0;
tstart = tic;
% pre-load all examples
h.load_all_examples();
h.describe();
examples = h.get_2_3_motions();
ne = length(examples);
fprintf('Number of 2, 3 motions: %d\n', ne);
for i=1:ne
    fprintf('Example (%d): ', i);
    example = examples{i};
    fprintf('%s, %d motions, %d points, %d frames;', example.name, example.num_motions, example.num_points, example.num_frames);
    switch example.num_motions
        case 2
            motion2 = motion2 + 1;
        case 3
            motion3 = motion3 + 1;
        otherwise
            error('Invalid number of motions.');
    end
    fprintf(' counts: ');
    fprintf('%d ', example.counts);
    [start_indices, end_indices] = spx.cluster.start_end_indices(example.counts);
    % The dataset
    X = example.X;
    fprintf(' effective rank: ');
    for k=1:example.num_motions
        ss = start_indices(k);
        ee = end_indices(k);
        XX = X(:, ss:ee);
        singular_values  = svd(XX, 'econ')';
        r = spx.la.svd.mahdi_rank(singular_values);
        fprintf('%d,  ', r);
    end
    fprintf('\n');

end
elapsed = toc(tstart);
fprintf('Time taken: %.2f seconds \n', elapsed);
fprintf('3 motions: %d\n', motion3);
fprintf('2 motions: %d\n', motion2);
