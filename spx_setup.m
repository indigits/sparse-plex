function [globals] = csf_setup()
% Let us get the full path of this file
globals.filepath = which(mfilename);
% Get the directory of this file
% This is the directory in which SparsePlex library is hosted.
globals.spx = fileparts(globals.filepath);


addpath(globals.spx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
globals.clustering = fullfile(globals.spx, 'clustering');
addpath(globals.clustering);
globals.sparse_subspace_clustering = fullfile(globals.clustering, 'sparse_subspace_clustering');
addpath(globals.sparse_subspace_clustering);
globals.spectral_clustering = fullfile(globals.clustering, 'spectral_clustering');
addpath(globals.spectral_clustering);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
globals.commons = fullfile(globals.spx, 'commons');
addpath(globals.commons);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
globals.data = fullfile(globals.spx, 'data');
addpath(globals.data);

globals.noise = fullfile(globals.data, 'noise');
addpath(globals.noise);

globals.synthetic = fullfile(globals.data, 'synthetic');
addpath(globals.synthetic);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
globals.dictionary = fullfile(globals.spx, 'dictionary');
addpath(globals.dictionary);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
globals.discrete = fullfile(globals.spx, 'discrete');
addpath(globals.discrete);

globals.combinatorics = fullfile(globals.discrete, 'combinatorics');
addpath(globals.combinatorics);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
globals.graphics = fullfile(globals.spx, 'graphics');
addpath(globals.graphics);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
globals.image_processing = fullfile(globals.spx, 'image_processing');
addpath(globals.image_processing);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
globals.io = fullfile(globals.spx, 'io');
addpath(globals.io);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
globals.linear_algebra = fullfile(globals.spx, 'linear_algebra');
addpath(globals.linear_algebra);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
globals.optimization = fullfile(globals.spx, 'optimization');
addpath(globals.optimization);

globals.convex_optimization = fullfile(globals.optimization, 'convex_optimization');
addpath(globals.convex_optimization);

globals.conjugate_gradient = fullfile(globals.convex_optimization, 'conjugate_gradient');
addpath(globals.conjugate_gradient);

globals.steepest_descent = fullfile(globals.convex_optimization, 'steepest_descent');
addpath(globals.steepest_descent);


globals.linear_programming = fullfile(globals.optimization, 'linear_programming');
addpath(globals.linear_programming);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
globals.probability = fullfile(globals.spx, 'probability');
addpath(globals.probability);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
globals.pursuit = fullfile(globals.spx, 'pursuit');
addpath(globals.pursuit);

globals.cosamp = fullfile(globals.pursuit, 'cosamp');
addpath(globals.cosamp);

globals.matching_pursuit = fullfile(globals.pursuit, 'matching_pursuit');
addpath(globals.matching_pursuit);

globals.orthogonal_matching_pursuit = fullfile(globals.pursuit, 'orthogonal_matching_pursuit');
addpath(globals.orthogonal_matching_pursuit);

globals.thresholding = fullfile(globals.pursuit, 'thresholding');
addpath(globals.thresholding);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
globals.signal_processing = fullfile(globals.spx, 'signal_processing');
addpath(globals.signal_processing);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
globals.statistical_signal_processing = fullfile(globals.spx, 'statistical_signal_processing');
addpath(globals.statistical_signal_processing);


end
