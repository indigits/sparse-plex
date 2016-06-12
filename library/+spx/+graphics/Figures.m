classdef Figures < handle
    %Figures Helps manage multiple figures in a demo
    
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
        function self = Figures(width, height)
            if ~exist('width', 'var')
                width = 800;
            end
            if ~exist('height', 'var')
                height = 600;
            end
            self.width = width;
            self.height = height;
            % Identify dual monitor situation
            positions = get(0, 'MonitorPositions');
            % position of first monitor
            m1_x = positions(1, 1);
            m1_y = positions(1, 2);
            self.x = m1_x + 50;
            self.y = m1_y + 100;
            self.number = 0;
            if size(positions, 1) > 1
                % We have dual monitor situation
                w1 = positions(1, 3);
                w2 = positions(2, 3);
                if w2 > w1
                    % Let us use the second monitor as default one.
                    self.x = self.x + w1;
                end
            end
        end
        
        function figH = new_figure(self, title)
            self.number = self.number + 1;
            if nargin < 2
                title = sprintf('figure %d', self.number);
            end
            figH = figure('Name', title...
                , 'Position', [self.x,self.y, self.width, self.height]...
                ,'NumberTitle','off', 'Color', 'w');
            self.x = self.x + self.X_SHIFT;
            self.y = self.y + self.Y_SHIFT;
        end

    end

    
end

