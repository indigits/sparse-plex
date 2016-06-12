classdef SPX_Draw < handle
% SPX_DRAW methods for drawing shapes on current axes

    methods(Static)


        function circle(x0, y0, r, options)
            % Draws a circle at specified location
            % the angular coordinates of the points on the circle which will be drawn
            theta = 0:pi/500:2*pi;
            % the x-cordinates of the points
            x = x0 + r*cos(theta);
            y = y0 + r*sin(theta);
            color = 'r';
            center_color = 'k';
            if nargin == 4
                if isfield(options, 'color')
                    color = options.color;
                end
                if isfield(options, 'center_color')
                    center_color = options.center_color;
                end
            end
            % we have a number of things to draw
            hold on;
            % we now draw the circle in red color
            spec = ['-' , color];
            plot( x, y, spec);
            % Lets plot the center of the circle
            spec = ['+' , center_color];
            plot(x0, y0, spec);
        end

        function varargout = norm_ball_2d(x0, y0, r, p, varargin)
        %DRAWNORMBALL2D Draw a 2D norm ball on the current axis
        %

        % ensure each parameter is column vector
        x0 = x0(:);
        y0 = y0(:);
        r = r(:);

        % default number of discretization steps
        N = 72;

        % parametrization variable for circle (use N+1 as first point counts twice)
        t = linspace(0, 1, N+1);
        % empty array for graphic handles
        h = zeros(size(x0));
        % compute discretization of each circle
        N = length(t);
        for i = 1:length(x0)
            %
            xt = zeros(length(t)*4, 1);
            yt = zeros(length(t)*4, 1);
            curRadius = r(i);
            xAxis = t*curRadius;
            yAxis = (curRadius^p  - xAxis.^p).^(1/p);
            xt(1:N) = xAxis(end:-1:1);
            yt(1:N) = yAxis(end:-1:1);
            xt(N+1:2*N) = -xAxis;
            yt(N+1:2*N) = yAxis;
            xt(2*N+1:3*N) = -xAxis(end:-1:1);
            yt(2*N+1:3*N) = -yAxis(end:-1:1);
            xt(3*N+1:4*N) = xAxis;
            yt(3*N+1:4*N) = -yAxis;
            %We now shift the origin
            xt = xt + x0(i);
            yt = yt + y0(i);
            h(i) = plot(gca, xt, yt, varargin{:});
        end

        if nargout > 0
            varargout = {h};
        end

        end
    end

end
