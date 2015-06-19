classdef SPX_MultiFigures < handle
    %SPX_MULTIFIGURES Helps manage multiple figures in a demo
    
    properties
        width
        height
        x
        y
        number
    end
    
    methods
        function self = SPX_MultiFigures(width, height)
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
        
        function figH = newFigure(self, title)
            self.number = self.number + 1;
            figH = figure('Name', title...
                , 'Position', [self.x,self.y, self.width, self.height]...
                ,'NumberTitle','off', 'Color', 'w');
            self.x = self.x + 50;
            self.y = self.y - 50;
        end
    end
    
end

