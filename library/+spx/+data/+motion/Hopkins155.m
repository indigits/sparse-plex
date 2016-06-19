classdef Hopkins155 < handle


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
            result.num_clusters = max(s);
            result.labels = s;
            x = data.x;
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
            X = reshape(permute(x(1:2,:,:),[1 3 2]),M,S);
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
