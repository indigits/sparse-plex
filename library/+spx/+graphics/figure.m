classdef figure 

    methods(Static)
        function [ h ] = full_screen(name)
            if nargin < 1
                name = [];
            end
            %full_screen Creates a full screen figure
            scrsz = get(0,'ScreenSize');
            w = scrsz(3);
            h = scrsz(4);
            h = figure('Position', [1 1 w h]);
            if ~isempty(name)
                set(h,'Name', name,'NumberTitle','off');
            end
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

        function move_to_large_monitor(fig_handle)
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
