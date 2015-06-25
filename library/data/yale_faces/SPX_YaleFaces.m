classdef SPX_YaleFaces < handle

    properties
        % These properties should be changed before loading the dataset
        ImagesToLoadPerSubject = 50 
    end
    properties(SetAccess=private)
        % The  root directory
        RootDir
        % The list of subjects with associated metadata
        Subjects
        % The gray-level data of images
        ImageData
        % Description of each image
        ImageDescriptions
        % Image Width and Height
        ImageWidth = 168
        ImageHeight = 192
    end

    methods
        function self = SPX_YaleFaces()
            self.RootDir = SPX_YaleFaces.yale_faces_dir();
        end
        function load(self)
            clk = tic;
            listing = dir(self.RootDir);
            n = length(listing);
            % pre-allocated array of subjects
            dummy = struct('subject_id',1, 'subject_dir', ''...
                , 'image_count', 0,  'ambient_image_count', 0 ...
                , 'loaded_image_count', 0);
            subjects = repmat(dummy, n, 1 );
            % pre allocated array of image descriptions
            dummy = struct('subject_idx',1, 'subject_id', 1 ...
                , 'image_idx', 0, 'image_glob_idx', 0, 'image_path', '' ...
                , 'ambient', false);
            image_descriptions = repmat(dummy, n*self.ImagesToLoadPerSubject, 1 );
            cache_path = SPX_YaleFaces.cach_file_path();
            if exist(cache_path, 'file') == 2
                cache = load(cache_path);
                image_data = cache.image_data;
                image_data_loaded = true;
            else
                image_data_loaded = false;
            end
            if ~image_data_loaded
                image_data = zeros(self.image_size(), n*self.ImagesToLoadPerSubject);
            end

            % iterate over subjects
            subject_count = 0;
            total_image_count = 0;
            for entry=listing'
                is_dir = entry.isdir;
                if ~is_dir
                    continue;
                end
                name = entry.name;
                k = strfind(name, 'yaleB');
                if isempty(k)
                    continue;
                end
                % We found a new subject
                subject_count = subject_count + 1;
                subject_id = str2num(name(6:end));
                subject_dir = fullfile(self.RootDir, name);
                subject.subject_id = subject_id;
                subject.subject_dir = subject_dir;
                image_files = dir(fullfile(subject_dir, '*.pgm'));
                image_count = 0;
                loaded_image_count = 0;
                ambient_image_count = 0;
                im_size = self.image_size();
                for image_file=image_files'
                    image_file_name = image_file.name;
                    k = strfind(image_file_name, 'mbient');
                    ambient = ~isempty(k);
                    if ambient
                        ambient_image_count = ambient_image_count + 1;
                        % We will not process ambient images
                        continue;
                    end
                    image_path = fullfile(subject_dir, image_file_name);
                    image_count = image_count + 1;
                    if loaded_image_count == self.ImagesToLoadPerSubject
                        % We have loaded enough images for this subject
                        continue;
                    end
                    % Load this image and associated description.
                    loaded_image_count = loaded_image_count + 1;
                    total_image_count = total_image_count + 1;
                    if ~image_data_loaded
                        % read the image
                        img = imread(image_path);
                        image_data(:, total_image_count) = reshape(img, im_size, 1);
                    end
                    image_desc = struct();
                    image_desc.subject_idx = subject_count;
                    image_desc.subject_id = subject_id;
                    image_desc.image_idx = loaded_image_count;
                    image_desc.image_glob_idx = total_image_count;
                    image_desc.image_path = image_path;
                    image_desc.ambient = ambient;
                    image_descriptions(total_image_count) = image_desc;
                end
                subject.image_count = image_count;
                subject.ambient_image_count = ambient_image_count;
                subject.loaded_image_count = loaded_image_count;
                subjects(subject_count) = subject;
                fprintf('.');
                if mod(subject_count, 10) == 0
                    fprintf('\n');
                end
            end
            subjects = subjects(1:subject_count);
            image_descriptions = image_descriptions(1:total_image_count);
            self.Subjects = subjects;
            self.ImageDescriptions = image_descriptions;
            % Reshape the images into 2-d matrix
            %[mm, nn, kk] = size(image_data);
            %image_data = reshape(image_data, mm, nn * kk);
            if ~image_data_loaded
                image_data = image_data(:, 1:total_image_count);
                save(cache_path, 'image_data');
            end
            self.ImageData = image_data;
            elapsed  = toc(clk);
            fprintf('\nTime taken in processing database: %.4f seconds\n', elapsed);
        end

        function result = num_subjects(self)
            result = length(self.Subjects);
        end

        function result = get_subject_images(self, subject_id)
            n = self.ImagesToLoadPerSubject ;
            start_index = (subject_id - 1) *  n;
            result = self.ImageData(:, start_index + (1:n));
        end


        function result = get_subject_images_resized(self, subject_id, width, height)
            n = self.ImagesToLoadPerSubject ;
            start_index = (subject_id - 1) *  n;
            orig_images = self.ImageData(:, start_index + (1:n));
            [s, n]  = size(orig_images);
            sz = width * height;
            resized_images = zeros(sz, n);
            w = self.ImageWidth;
            h = self.ImageHeight;
            for i=1:n
                image = reshape(orig_images(:, i), h, w);
                resized_image = imresize(image, [height, width]);
                resized_images(:, i) = reshape(resized_image, sz, 1);
            end
            result = resized_images;
        end


        function result = num_total_images(self)
            result = length(self.ImageDescriptions);
        end

        function result = image_size(self)
            result = self.ImageWidth * self.ImageHeight;
        end

        function result = get_image_by_glob_idx(self, index)
            img = self.ImageData(:, index);
            img = reshape(img, self.ImageWidth, self.ImageHeight);
        end

        function resize_all(self, width, height)
            % resizes all images to specified size
            orig_images = self.ImageData;
            [s, n]  = size(orig_images);
            sz = width * height;
            resized_images = zeros(sz, n);
            w = self.ImageWidth;
            h = self.ImageHeight;
            for i=1:n
                image = reshape(orig_images(:, i), h, w);
                resized_image = imresize(image, [height, width]);
                resized_images(:, i) = reshape(resized_image, sz, 1);
            end
            self.ImageData = resized_images;
            self.ImageWidth = width;
            self.ImageHeight = height;
        end

        function describe(self)
            fprintf('Root directory: %s\n', self.RootDir);
            fprintf('Number of subjects: %d\n', self.num_subjects());
            fprintf('Number of images: %d\n', self.num_total_images());
            for subject=self.Subjects'
                fprintf('Subject id: %4d, Images: %4d, Ambient: %4d, Loaded: %4d\n', ...
                    subject.subject_id, ...
                    subject.image_count, subject.ambient_image_count, ...
                    subject.loaded_image_count);
            end
        end

        function canvas = create_random_canvas(self, rows, cols)
            n = self.num_subjects();
            if nargin < 2
                rows = 4;
            end
            if nargin < 3
                cols = rows;
            end
            k  = rows * cols;
            indices = randperm(n, k);
            indices = (indices - 1) * self.ImagesToLoadPerSubject + 1;
            images = self.ImageData(:, indices);
            canvas = SPX_Canvas.create_image_grid(images, rows, cols, ...
                self.ImageHeight, self.ImageWidth);
            canvas = uint8(canvas);
        end

        function canvas = create_subject_canvas(self, subject_id)
            subject_images = self.get_subject_images(subject_id);
            rows = 5;
            cols = 10;
            canvas = SPX_Canvas.create_image_grid(subject_images, rows, cols, ...
                self.ImageHeight, self.ImageWidth);
            canvas = uint8(canvas);
        end

        function images = training_set_a(self)
            % Pick ten random images from each subject
            rng('default');
            images_per_subject = 10;
            indices = randperm(self.ImagesToLoadPerSubject, images_per_subject);
        end
    end

    methods(Static)
        function root_dir = yale_faces_dir()
            % This should be changed to whatever place the faces are maintained.
            root_dir = 'D:\Phd\TestFiles\Images\Faces\CroppedYale';
        end

        function result = cach_file_path()
            this_file_path = mfilename('fullpath');
            this_dir = fileparts(this_file_path);
            result = fullfile(this_dir, 'yale_cache.mat');
        end
    end

end
