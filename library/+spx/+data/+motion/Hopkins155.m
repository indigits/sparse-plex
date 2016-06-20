classdef Hopkins155 < handle

% The variables inside the ground-truth file are organized as follow:
% . width and height: dimensions (in pixels) of all the frames in the
%   video sequence.
% . points: number of tracked points P.
% . frames: number of frames F.
% . y: a matrix 3xPxF containing the homogeneous coordinates of the P
%   points in the F frames.
% . x: a matrix 3xPxF derived from y by normalizing the first two
%   components of each vector such that they belong to the interval
%   [-1;1].
% . K: the 3x3 normalization matrix used to pass from y to x
%   (x=K^(-1)*x).
% . s: a Px1 vector containing the ground-truth segmentation; for each
%   point it gives the index of the corresponding motion group.


properties(SetAccess=private)
    root_dir
    % names of examples
    example_names
    % paths of example data
    example_paths
    % data of each example
    examples
end

methods

    function self = Hopkins155()
        self.root_dir = spx.data.local.hopkins155_dir();
        self.example_names = cell(0, 1);
        self.example_paths = cell(0, 1);
        self.load();
    end

    function load(self)
        listing = dir(self.root_dir);
        for i=1:length(listing)
            % we iterate through each directory
            entry = listing(i);
            if ~entry.isdir
                continue;
            end
            % ignore . and .. directories
            if strcmp(entry.name, '.')
                continue;
            end
            if strcmp(entry.name, '..')
                continue;
            end
            subdir = fullfile(self.root_dir, entry.name);
            sub_listing = dir(subdir);
            % the directory must have a file with _truth.mat extension
            valid_data = false;
            for j=1:length(sub_listing)
                subentry = sub_listing(j);
                fname = subentry.name;
                tmp = strfind(fname, '_truth.mat');
                if ~isempty(tmp)
                    valid_data = true;
                    break;
                end
            end
            if ~valid_data
                % we can ignore this directory
                continue;
            end
            self.example_names{end+1} = entry.name;
            self.example_paths{end+1} = fullfile(subdir, fname);
        end
        % data will be loaded in this array
        self.examples = cell(1, length(self.example_names));
    end

    function result = num_examples(self)
        result = length(self.example_names);
    end

    function result = get_example(self, n)
        if n < 1 || n > self.num_examples()
            error('Invalid example number.');
        end
        result = self.examples{n};
        if isempty(result)
            % this example is not yet loaded.
            path = self.example_paths{n};
            data = load(path);
            % let's fill up more info
            s = data.s;
            % ensure that s is a row vector
            if iscolumn(s)
                s = s';
            end
            result.num_clusters = max(s);
            % let us work through the labels to reorder them
            % such that points from each subspace are adjacent.
            mapping = [];
            counts = [];
            labels = [];
            for k=1:result.num_clusters
                % entries for k-th cluster
                entries = find(s == k);
                mapping = [mapping entries];
                count = length(entries);
                counts = [counts count];
                labels = [labels k*ones(1, count)];
            end
            % labels of points
            result.labels = labels;
            % counts of each cluster
            result.counts = counts;
            x = data.x;
            % reorder x
            x = x(:, mapping, :);
            % number of points
            S = size(x, 2);
            % number of frames
            F = size(x, 3);
            result.num_frames = F;
            result.num_points = S;
            % Ambient dimension
            M = 2 * F;
            result.M  = M;
            % reshape the data in x for clustering purpose
            % drop the third component of each point in x [homogeneous part]
            x = x(1:2,:,:);
            % now x is 2xPxF (P : points, F is frames)
            % bring frames dimension ahead and points dimension behind
            x = permute(x,[1 3 2]);
            % Now map the 2 coordinates of each point in each column
            X = reshape(x,M,S);
            result.X = X;
            % clean up unnecessary fields
            %fields = {'x', 'y', 's', 'width', 'height', 'frames', 'K'};
            %rmfield(result, fields);
            % finally store it.
            self.examples{n} = result;
        end
    end

    function load_all_examples(self)
        n = self.num_examples;
        for i=1:n
            self.get_example(i);
        end
    end
    
    function result = get_all_examples(self)
        self.load_all_examples();
        result = self.examples;
    end
end

end
