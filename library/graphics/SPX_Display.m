classdef SPX_Display

    methods(Static)

        function [ figH ] = display_gram_matrix( Phi )
            %DISPLAYGRAMMATRIX Displays the Gram matrix of a given matrix
            G = Phi' * Phi;
            absG = abs(G);
            % Let us set all the diagonal elements to zero
            absG(logical(eye(size(absG)))) = 0;
            figH = SPX_Figures.full_screen_figure;
            imagesc(absG);
            colormap(gray);
        end

    end
end


