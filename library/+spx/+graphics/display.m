classdef display

methods(Static)

    function matrix(A, options)
        fresh_figure = true;
        % We are choosing our colormap
        color_map = 'copper';
        if nargin == 2
            if isfield(options, 'fresh_figure')
                fresh_figure = options.fresh_figure;
            end
            if isfield(options, 'color_map')
                color_map = options.color_map;
            end
        end
        if fresh_figure
            spx.graphics.figure.full_screen;
        end
        % The matrix displayed as image
        imagesc(A);
        % Set the color map
        colormap(color_map);
        % Make sure that axis is square.
        axis square;
        % Do not show the axis.
        axis off;
    end



    function figure_handle = dictionary_atoms_as_images(dict, options)
        figure_handle = spx.graphics.figure.full_screen;
        [N, D] = size(dict);
        [rows, cols] = spx.discrete.number.integer_factors_close_to_sqr_root(D);
        counter = 0;
        [pixel_rows, pixel_cols] = spx.discrete.number.integer_factors_close_to_sqr_root(N);
        for r=1:rows
            for c=1:cols
                counter = counter + 1;
                subplot(rows, cols, counter);
                atom = dict(:, counter);
                atomImage = reshape(atom, pixel_rows, pixel_cols);
                atomImage = mat2gray(atomImage);
                subimage(atomImage);
                axis off;
            end
        end
        if nargin > 1
            if isfield(options, 'title')
                spx.graphics.suptitle(options.title);
            end
        end
    end

    function [ figH ] = display_gram_matrix( Phi )
        % Displays the Gram matrix of a given matrix
        G = Phi' * Phi;
        absG = abs(G);
        % Let us set all the diagonal elements to zero
        absG(logical(eye(size(absG)))) = 0;
        figH = spx.graphics.figure.full_screen;
        imagesc(absG);
        colormap(gray);
    end

end

end


