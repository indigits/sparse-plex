classdef SPX_Image

methods(Static)

    function image = read_gray_image(filepath)
        % Reads a gray level image
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
