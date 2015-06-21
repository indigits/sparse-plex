classdef SPX_RecoveryProblems < handle

    methods(Static)

        function problem = problem_small_1()
            m = 64;
            n = 121;
            k = 4;
            dict = SPX_SimpleDicts.Gaussian(m, n);
            gen = SPX_SparseSignalGenerator(n, k);
            % create a sparse vector
            rep =  gen.biGaussian();
            signal = dict*rep;
            problem.dictionary = dict;
            problem.representation_vector = rep;
            problem.sparsity_level = k;
            problem.signal_vector = signal;
        end

        function problem = problem_large_1()
            m = 1000;
            n = 2000;
            k = 100;
            dict = SPX_SimpleDicts.Gaussian(m, n);
            gen = SPX_SparseSignalGenerator(n, k);
            % create a sparse vector
            rep =  gen.biGaussian();
            signal = dict*rep;
            problem.dictionary = dict;
            problem.representation_vector = rep;
            problem.sparsity_level = k;
            problem.signal_vector = signal;
        end


        function problem = problem_barbara_blocks()
            image = SPX_RecoveryProblems.read_image('D:\Phd\TestFiles\Images\standard_test_images\barbara.png');
            blkSize = 8;
            patches = im2col(image, [blkSize, blkSize], 'distinct');
            problem.signals = patches;
            problem.image = image;
            problem.blkSize = blkSize;
            problem.sparsity_level = 4;
            % Let's prepare a dictionary for the image
            N = 64;
            D = 121;
            problem.dictionary = SPX_SimpleDicts.overcomplete2DDCT(N, D);
        end

        function problem = problem_test_image_blocks(image_name, block_type)
            if nargin < 2
                block_type = 'distinct';
            end
            rootdir = 'D:\Phd\TestFiles\Images\standard_test_images';
            switch image_name
                case 'barbara'
                    fname = 'barbara.png';
                case 'cameraman'
                    fname = 'cameraman.tif';
                case 'house'
                    fname = 'house.tif';
                case 'jetplane'
                    fname = 'jetplane.tif';
                case 'lake'
                    fname = 'lake.tif';
                case 'lena'
                    fname = 'lena_gray_512.tif';
                case 'livingroom'
                    fname = 'livingroom.tif';
                case 'mandril'
                    fname = 'mandril_gray.tif';
                case 'peppers'
                    fname = 'peppers_gray.tif';
                case 'pirate'
                    fname = 'pirate.tif';
                case 'walkbridge'
                    fname = 'walkbridge.tif';
                case 'blonde'
                    fname = 'woman_blonde.tif';
                case 'darkhair'
                    fname = 'woman_darkhair.tif';
                otherwise
                    error('Unsupported test image');
            end
            filepath = fullfile(rootdir, fname);
            image = SPX_RecoveryProblems.read_image(filepath);
            blkSize = 8;
            patches = im2col(image, [blkSize, blkSize], block_type);
            problem.signals = patches;
            problem.image = image;
            problem.blkSize = blkSize;
        end

        function image = read_image(filepath)
            [image,~]=imread(filepath);
            image = im2double(image);
            % If the image is RGB, let us convert it to gray
            sz = size(image);
            if (length(sz) > 2)
                if sz(3) == 2
                    image = image(:, :, 1);
                elseif sz(3) == 3
                    image = rgb2gray(image);
                end
            end
            % Let us bring image to 0-255 range
            if max(image(:)) < 2
                image = image * 255;
            end
        end

    end


end
