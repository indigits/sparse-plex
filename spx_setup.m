function [globals] = spx_setup()
% Let us get the full path of this file
globals.filepath = which(mfilename);
% Get the directory of this file
% This is the directory in which SparsePlex library is hosted.
globals.root = fileparts(globals.filepath);
% This is the directory where source-plex library code is hosted.
globals.spx = fullfile(globals.root, 'library');


addpath(globals.root);
addpath(globals.spx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
globals.clustering = fullfile(globals.spx, 'clustering');
addpath(globals.clustering);

globals.clustering_kmeans = fullfile(globals.clustering, 'kmeans');
addpath(globals.clustering_kmeans);

globals.sparse_representation_clustering = fullfile(globals.clustering, 'sparse_representation_clustering');
addpath(globals.sparse_representation_clustering);


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

globals.data_clustering = fullfile(globals.data, 'clustering');
addpath(globals.data_clustering);


globals.data_noise = fullfile(globals.data, 'noise');
addpath(globals.data_noise);

globals.data_synthetic = fullfile(globals.data, 'synthetic');
addpath(globals.data_synthetic);

globals.data_signals = fullfile(globals.data, 'signals');
addpath(globals.data_signals);

globals.data_yale_faces = fullfile(globals.data, 'yale_faces');
addpath(globals.data_yale_faces);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
globals.ext = fullfile(globals.spx, 'ext');
addpath(globals.ext);
% support for spx_ini2struct function
addpath(fullfile(globals.ext, 'ini2struct'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
globals.dictionary = fullfile(globals.spx, 'dictionary');
addpath(globals.dictionary);
globals.dictionary_learning = fullfile(globals.dictionary, 'learning');
addpath(globals.dictionary_learning);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
globals.discrete = fullfile(globals.spx, 'discrete');
addpath(globals.discrete);

globals.combinatorics = fullfile(globals.discrete, 'combinatorics');
addpath(globals.combinatorics);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
globals.graphics = fullfile(globals.spx, 'graphics');
addpath(globals.graphics);
addpath(fullfile(globals.graphics, 'export_fig'));

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

globals.single_recovery = fullfile(globals.pursuit, 'single_recovery');
addpath(globals.single_recovery);


% Joint recovery algorithms
globals.joint_recovery = fullfile(globals.pursuit, 'joint_recovery');
addpath(globals.joint_recovery);

% cluster omp
globals.comp = fullfile(globals.joint_recovery, 'comp');
addpath(globals.comp);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
globals.signal_processing = fullfile(globals.spx, 'signal_processing');
addpath(globals.signal_processing);

globals.digital_communication = fullfile(globals.signal_processing, 'digital_communication');
addpath(globals.digital_communication);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
globals.statistical_signal_processing = fullfile(globals.spx, 'statistical_signal_processing');
addpath(globals.statistical_signal_processing);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
globals.statistics = fullfile(globals.spx, 'statistics');
addpath(globals.statistics);
globals.statistics_detection = fullfile(globals.statistics, 'detection');
addpath(globals.statistics_detection);
globals.statistics_estimation = fullfile(globals.statistics, 'estimation');
addpath(globals.statistics_estimation);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
globals.wavelet = fullfile(globals.spx, 'wavelet');
addpath(globals.wavelet);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Following process is for getting the default settings
% for different data directories in local environment.
default_settings_path = fullfile(globals.root, 'spx_defaults.ini');
local_settings_path = fullfile(globals.root, 'spx_local.ini');
if ~exist(local_settings_path, 'file')
    fprintf('Copying default settings file to local settings file.\n');
    copyfile(default_settings_path, local_settings_path);
end
globals.local_settings = spx_ini2struct(local_settings_path);
spx_settings_cache = fullfile(globals.root, 'spx_local_settings.mat');
save(spx_settings_cache, 'globals');
end

