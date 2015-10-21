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

    methods(Static)
        function [ h ] = full_screen_figure()
            %FULL_SCREEN_FIGURE Creates a full screen figure
            scrsz = get(0,'ScreenSize');
            w = scrsz(3);
            h = scrsz(4);
            h = figure('Position', [1 1 w h]);
        end

        % This is a bad idea.
        % function default_on_secondary_monitor()
        %     positions = get(0, 'MonitorPositions');
        %     second_monitor  = positions(2, :);
        %     x = second_monitor(1);
        %     y = second_monitor(2);
        %     w = second_monitor(3);
        %     h  = second_monitor(4);
        %     set(0,'DefaultFigurePosition', [(x+200) 200 600 400]);
        % end

        function move_figure_to_large_monitor(fig_handle)
            if nargin < 1
                fig_handle  = gcf;
            end
            position = get(fig_handle, 'Position');
            cur_x = position(1);
            cur_y = position(2);
            % Identify dual monitor situation
            monitor_positions = get(0, 'MonitorPositions');
            if size(monitor_positions, 1) > 1
                % We have dual monitor situation
                w1 = monitor_positions(1, 3);
                w2 = monitor_positions(2, 3);
                if w2 > w1
                    y2 = monitor_positions(2, 2);
                    % Let us use the second monitor as default one.
                    cur_x = cur_x + w1;
                    cur_y = cur_y - y2;
                    set(fig_handle, 'Position',[cur_x, cur_y, position(3:4)]);
                end
            end
        end
    end
    
end

