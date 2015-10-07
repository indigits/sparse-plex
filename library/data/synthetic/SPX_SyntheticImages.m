classdef SPX_SyntheticImages < handle

methods(Static)

    function image = horizontal_zebra(height, width, strip_size, colors)
        % Example: 
        % - SPX_SyntheticImages.horizontal_zebra(15, 10, 3, [0 64, 128, 255])

        % construct the image
        image = zeros(height, width, 'uint8');
        % Number of colors 
        ncolors = length(colors);
        % height as unsigned integer
        i_height = uint32(height);
        % strip size as unsigned integer
        i_strip_size = uint32(strip_size);
        % number of strips (allowing last strip to be smaller than size)
        i_num_strips = idivide(i_height , i_strip_size, 'ceil');
        num_strips = double(i_num_strips);
        % strip numbers
        strip_numbers = 1:num_strips;
        % sizes of each strip
        strip_sizes = strip_size * ones(1, num_strips);
        % calculate the size of last strip
        if num_strips * strip_size > height
            % The last strip is smaller
            last_strip_size = height - (num_strips -1) * strip_size;
            strip_sizes(end) = last_strip_size;
        end
        % assign color numbers to each strip
        color_numbers = mod(strip_numbers-1, ncolors) +1;
        % fill in the data for each strip
        start_row = 0;
        for strip_number=strip_numbers
            strip_height = strip_sizes(strip_number);
            color_number = color_numbers(strip_number);
            color = colors(color_number);
            image(start_row + (1:strip_height), :) = color;
            start_row = start_row + strip_height;
        end
    end


    function image = vertical_zebra(height, width, strip_size, colors)
        % Example: 
        % - SPX_SyntheticImages.vertical_zebra(15, 10, 3, [0 64, 128, 255])

        % construct the image
        image = zeros(height, width, 'uint8');
        % Number of colors 
        ncolors = length(colors);
        % width as unsigned integer
        i_width = uint32(width);
        % strip size as unsigned integer
        i_strip_size = uint32(strip_size);
        % number of strips (allowing last strip to be smaller than size)
        i_num_strips = idivide(i_width , i_strip_size, 'ceil');
        num_strips = double(i_num_strips);
        % strip numbers
        strip_numbers = 1:num_strips;
        % sizes of each strip
        strip_sizes = strip_size * ones(1, num_strips);
        % calculate the size of last strip
        if num_strips * strip_size > width
            % The last strip is smaller
            last_strip_size = width - (num_strips -1) * strip_size;
            strip_sizes(end) = last_strip_size;
        end
        % assign color numbers to each strip
        color_numbers = mod(strip_numbers-1, ncolors) +1;
        % fill in the data for each strip
        start_col = 0;
        for strip_number=strip_numbers
            strip_width = strip_sizes(strip_number);
            color_number = color_numbers(strip_number);
            color = colors(color_number);
            image(:, start_col + (1:strip_width)) = color;
            start_col = start_col + strip_width;
        end
    end

end

end

