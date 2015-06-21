classdef SPX_Canvas
    %SPX_IMAGEGRIDCANVAS Helps in displaying images in the form of a grid.
    
    properties
    end
    
    methods(Static)
        function canvas = create_image_grid(images, ...
                rows, cols, height, width)
            % Input parameters
            %   images: The images
            %   rows: number of rows to display
            %   cols: number of columns to display
            %   height: height of each patch
            %   width : width of each patch
            borderSize = 1;
            % n : signal space dimension
            % d : number of images
            [n, d] = size(images);
            if ~exist('height', 'var') || ~exist('width', 'var')
                height = sqrt(n);
                width = sqrt(n);
            end
            if ~exist('rows', 'var') || ~exist('cols', 'var')
                rows = sqrt(d);
                cols = sqrt(d);
            end
            imageSize = round(sqrt(n) + borderSize);
            totalRows = imageSize*rows + borderSize;
            totalCols = imageSize * cols + borderSize;
            % Allocate space for RGB canvas
            canvas = zeros(totalRows, totalCols, 3);
            canvas(:,:, 1) = 0.9;
            canvas(:,:, 2) = 0.9;
            canvas(:,:, 3) = 1;
            
            % We now fill the image with images
            patchNumber = 1;
            for r=1:rows
                for c=1:cols
                    patch = images(:, patchNumber);
                    image = reshape(patch, height, width);
                    rr = borderSize + (r-1) * (height + borderSize);
                    cc = borderSize + (c-1)* (width + borderSize);
                    % Fill the image in R,G,B components
                    canvas(rr + (1:height), cc + (1:width), 1) = image; 
                    canvas(rr + (1:height), cc + (1:width), 2) = image; 
                    canvas(rr + (1:height), cc + (1:width), 3) = image; 
                    patchNumber = patchNumber + 1;
                    if patchNumber > d
                        % We don't have any more images to show.
                        break;
                    end
                end
                if patchNumber > d
                    % We don't have any more images to show.
                    break;
                end
            end
        end

        function canvas = create_signal_matrix_canvas(signalMatrix)
            % Input parameters
            % signalMatrix signals to be displayed.
            signalMatrix = im2uint8(mat2gray(signalMatrix));
            % n : signal space dimension
            % d : number of patches
            [N, S] = size(signalMatrix);
            blkSize = 10;
            rows = N*blkSize + 2;
            columns = S*(blkSize + 1) + 1;
            canvas = zeros(rows, columns);
            canvas(:, 1) = 0;
            col = 2;
            for s=1:S
                signal = signalMatrix(:, s);
                signal2 = zeros(rows, 1);
                signal2(1) = 0;
                r = 2;
                for n=1:N
                    signal2(r:r+blkSize-1) = signal(n);
                    r = r+blkSize;
                end
                for j=1:blkSize
                    canvas(:, col) = signal2;
                    col = col +  1;
                end
                canvas(:, col) = 0;
                col = col + 1;
            end
            canvas = uint8(canvas);
        end

    end
    
end

