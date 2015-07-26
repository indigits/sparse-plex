% Standard test images
classdef SPX_TestImages

methods(Static)

    function image_dir = test_image_dir()
        here = which(mfilename);
        data = fileparts(here);
        library = fileparts(data);
        spx = fileparts(library);
        image_dir = fullfile(spx, 'data', 'images');
    end

    function image = barbara_gray_512x512()
        % Returns the Barbara image
        filepath = fullfile(SPX_TestImages.test_image_dir(), 'barbara_gray_512x512.png');
        image = SPX_Image.read_gray_image(filepath);
    end

    function image = cameraman_gray_512x512()
        % Returns the Barbara image
        filepath = fullfile(SPX_TestImages.test_image_dir(), 'cameraman_gray_512x512.tif');
        image = SPX_Image.read_gray_image(filepath);
    end

    function image = jetplane_gray_512x512()
        % Returns the Barbara image
        filepath = fullfile(SPX_TestImages.test_image_dir(), 'jetplane_gray_512x512.tif');
        image = SPX_Image.read_gray_image(filepath);
    end

    function image = lake_gray_512x512()
        % Returns the Barbara image
        filepath = fullfile(SPX_TestImages.test_image_dir(), 'lake_gray_512x512.tif');
        image = SPX_Image.read_gray_image(filepath);
    end

    function image = lena_gray_512x512()
        % Returns the Barbara image
        filepath = fullfile(SPX_TestImages.test_image_dir(), 'lena_gray_512x512.tif');
        image = SPX_Image.read_gray_image(filepath);
    end

    function image = peppers_gray_512x512()
        % Returns the Barbara image
        filepath = fullfile(SPX_TestImages.test_image_dir(), 'peppers_gray_512x512.tif');
        image = SPX_Image.read_gray_image(filepath);
    end

    function image = pirate_gray_512x512()
        % Returns the Barbara image
        filepath = fullfile(SPX_TestImages.test_image_dir(), 'pirate_gray_512x512.tif');
        image = SPX_Image.read_gray_image(filepath);
    end


end

end
