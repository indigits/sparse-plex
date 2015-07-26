classdef SPX_Figures < handle
    %SPX_MULTIFIGURES Helps manage multiple figures in a demo
    
    properties
        width
        height
        x
        y
        number
        X_SHIFT = 50
        Y_SHIFT = -50
    end
    
    methods
        function self = SPX_Figures(width, height)
            if ~exist('width', 'var')
                width = 800;
            end
            if ~exist('height', 'var')
                height = 600;
            end
            self.width = width;
            self.height = height;
            self.x = 50;
            self.y = 200;
            self.number = 0;
        end
        
        function figH = new_figure(self, title)
            self.number = self.number + 1;
            figH = figure('Name', title...
                , 'Position', [self.x,self.y, self.width, self.height]...
                ,'NumberTitle','off', 'Color', 'w');
            self.x = self.x + self.X_SHIFT;
            self.y = self.y + self.Y_SHIFT;
        end

    end

    methods(Static)
        function [ h ] = full_screen_figure()
            %FULL_SCREEN_FIGURE Creates a full screen figure
            scrsz = get(0,'ScreenSize');
            w = scrsz(3);
            h = scrsz(4);
            h = figure('Position', [1 1 w h]);
        end
    end
    
end

