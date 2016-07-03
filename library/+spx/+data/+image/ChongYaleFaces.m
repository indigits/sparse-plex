classdef ChongYaleFaces < handle
% This class is a wrapper over the dataset created by
% Chong You, 2016[ExtendedYaleB.mat, https://sites.google.com/site/chongyou1987/] . 
% The images are already  cropped.
properties
end
properties(SetAccess=private)
    % the data file from which everything is loaded.
    file_path
    % the raw data loaded from file
    data
    % image height
    image_height
    % image width
    image_width
    % number of subjects in database
    num_subjects
    %  The data set
    Y
    % The labels
    labels
    % The cluster sizes
    cluster_sizes
    % positions for individual clusters
    start_indices
    end_indices
end

properties(Access=private)
    subject_sets_map 
end

methods
    function self = ChongYaleFaces()
        root = spx.data_dir;
        self.file_path = fullfile(root, 'faces', 'ExtendedYaleB.mat');
        data = load(self.file_path);
        self.image_height = 48;
        self.image_width = 42;
        self.num_subjects = 38;
        self.labels = data.EYALEB_LABEL;
        self.Y = data.EYALEB_DATA;
        self.cluster_sizes = spx.cluster.cluster_sizes_from_labels(self.labels);
        [self.start_indices, self.end_indices] = spx.cluster.start_end_indices(self.cluster_sizes);
        self.subject_sets_map = cell(1, 10);
    end

    function result = num_total_faces(self)
        result = sum(self.cluster_sizes);
    end

    function result = subject_faces_as_matrices(self, i)
        error('Not implemented.');
        % Returns all faces of a subject as matrices
        result = self.data.I(:, :, i, :);
    end

    function result = subject_faces_as_columns(self, i)
        % Returns all faces of a subject as column vectors
        s= self.start_indices(i);
        e = self.end_indices(i);
        result = self.Y(:, s:e);
    end

    function result = sets_of_n_subjects(self, n)
        if n < 1 || n > 10
            error('Number of subjects must be between 1 and 10');
        end
        if ~isempty(self.subject_sets_map{n})
            result = self.subject_sets_map{n};
            return;
        end
        result1 = nchoosek(1:10, n);
        result2 = nchoosek(11:20, n);
        result3 = nchoosek(21:30, n);
        result = [result1; result2; result3];
        if n <= 8
            result4 = nchoosek(31:38, n);
            result = [result; result4];
        end
        self.subject_sets_map{n} = result;
    end

    function result = num_experiments_of_n_subjects(self, n)
        sets = self.sets_of_n_subjects(n);
        result = size(sets, 1);
    end

    %% experiment_data: Returns data for a particular experiment
    function [Y, cluster_sizes, labels] = experiment_data(self, n, i)
        sets = self.sets_of_n_subjects(n);
        nn  = size(sets, 1);
        if i < 1 || i > nn
            error('Invalid experiment number.');
        end
        indices = sets(i, :);
        Y = [];
        cluster_sizes = self.cluster_sizes(indices);
        for k=1:n
            subject_index = indices(k);
            Y = [Y self.subject_faces_as_columns(subject_index)];
        end
        labels = spx.cluster.labels_from_cluster_sizes(cluster_sizes);
    end
    

    function [faces, cluster_sizes, labels] = all_faces(self)
        faces = self.Y;
        cluster_sizes = self.cluster_sizes;
        labels = self.labels;
    end

    function canvas = create_random_canvas(self, rows, cols)
        n = self.num_subjects;
        if nargin < 2
            rows = 4;
        end
        if nargin < 3
            cols = rows;
        end
        k  = rows * cols;
        indices = randperm(n, k);
        faces = self.all_faces;
        % pick first image for each subject
        indices = self.start_indices(indices);
        images = faces(:, indices);
        canvas = spx.graphics.canvas.create_image_grid(images, rows, cols, ...
            self.image_height, self.image_width);
        canvas = uint8(canvas);
    end


end


end
