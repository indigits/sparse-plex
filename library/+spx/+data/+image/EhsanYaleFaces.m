classdef EhsanYaleFaces < handle
% This class is a wrapper over the dataset created by
% Ehsan Elhamifar, 2012. The images are already 
% cropped.
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
    % number of faces per subject
    num_faces_per_subject
end
methods
    function self = EhsanYaleFaces()
        root = spx.data_dir;
        self.file_path = fullfile(root, 'faces', 'YaleBCrop025.mat');
        self.data = load(self.file_path);
        [h, w, nf, ns] = size(self.data.I);
        self.image_height = h;
        self.image_width = w;
        self.num_subjects = ns;
        self.num_faces_per_subject = nf;
    end

    function result = num_total_faces(self)
        result = self.num_subjects * self.num_faces_per_subject;
    end

    function result = subject_faces_as_matrices(self, i)
        % Returns all faces of a subject as matrices
        result = self.data.I(:, :, i, :);
    end

    function result = subject_faces_as_columns(self, i)
        % Returns all faces of a subject as column vectors
        result = self.data.Y(:, :, i);
    end

    function result = sets_of_n_subjects(self, n)
        if n < 1 || n > 10
            error('Number of subjects must be between 1 and 10');
        end
        result = self.data.Ind{n};
    end

    function result = num_experiments_of_n_subjects(self, n)
        if n < 1 || n > 10
            error('Number of subjects must be between 1 and 10');
        end
        sets = self.data.Ind{n};
        result = size(sets, 1);
    end

    %% experiment_data: Returns data for a particular experiment
    function [Y, labels] = experiment_data(self, n, i)
        if n < 1 || n > 10
            error('Number of subjects must be between 1 and 10');
        end
        sets = self.data.Ind{n};
        nn  = size(sets, 1);
        if i < 1 || i > nn
            error('Invalid experiment number.');
        end
        indices = sets(i, :);
        Y = []
        for k=1:n
            subject_index = indices(k);
            Y = [Y self.subject_faces_as_columns(k)];
        end
        labels = self.data.s{n};
    end
    

    function [faces, sizes, labels] = all_faces(self)
        [n, num_faces_per_subject, num_subjects] = size(self.data.Y);
        total_faces = num_subjects * num_faces_per_subject;
        faces = reshape(self.data.Y, [n, total_faces]);
        sizes = num_faces_per_subject * ones(1, num_subjects) ;
        labels = spx.cluster.labels_from_cluster_sizes(sizes);
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
        indices = (indices - 1) * self.num_faces_per_subject +1;
        images = faces(:, indices);
        canvas = spx.graphics.canvas.create_image_grid(images, rows, cols, ...
            self.image_height, self.image_width);
        canvas = uint8(canvas);
    end


end


end
