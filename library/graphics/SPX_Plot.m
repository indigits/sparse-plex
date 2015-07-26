classdef SPX_Plot

methods(Static)

    function [ figure_handle ] = discrete_signal( x, options)
        %discrete_signal Plots a discrete signal
        titleStr = 'Signal x(n)';
        xLabel = 'n';
        yLabel = 'x(n)';
        if exist('options', 'var')
            if isfield(options, 'title')
                titleStr = options.title;
            end
            if isfield(options, 'xlabel')
                xLabel = options.xlabel;
            end
            if isfield(options, 'ylabel')
                yLabel = options.ylabel;
            end
        end
        figure_handle = SPX_Figures.full_screen_figure;
        stem(x, '.');
        grid;
        title(titleStr);
        xlabel(xLabel);
        ylabel(yLabel);
        n = length(x);
        set(gca,'xlim', [.5 (n + 0.5)]);
        if exist('options', 'var')
            if isfield(options, 'xstep')
                n = length(x);
                set(gca,'XTick',1:options.xstep:n);
            end
        end
    end


    function figure_handle = filter_response_h_x_y( h, x, y )
        % Plots response of an FIR filter
        %
        % Three subplots are created one for each h, x, and y.
        % We assume that length(x) = length(y) and both are vectors
        % Also assume that length(h) <= length(x)
        figure_handle = SPX_Figures.full_screen_figure;
        N = length(x);

        % Plot the FIR filter
        subplot(311);
        stem(0:(length(h)-1), h, '.');
        grid;
        title('h[n]');
        n = length(h);
        set(gca,'xlim', [-1 n]);
        set(gca,'XTick',-1:1:n);
        set(gca, 'ylim', [0 0.5]);

        subplot(312);
        stem(0:N-1, x, '.');
        grid;
        set(gca,'xlim', [-1 N]);
        title('x[n]');

        subplot(313);
        stem(0:N-1, y, '.');
        set(gca,'xlim', [-1 N]);
        title('y[n]');
        grid;
    end


    function [ figure_handle ] = frequency_response(Xf, options)
        % Plots frequency response
        % Assumes response is in [0,1] range
        % Performs shifting to [-0.5 0.5] range
        % Plots accordingly
        % We assume that Xf has been computed using FFT.


        % A flag to indicate if magnitude response is to be plotted in dB.
        decibels = false;
        if nargin == 2
            if isfield(options, 'decibels')
                decibels = options.decibels;
            end
        end
        % Number of entries in the frequency response
        N = length(Xf);
        % Let's center the response from [0, 1] to [-0.5 0.5];
        Xf = fftshift(Xf);
        % Identify magnitude response
        magnitude = abs(Xf);
        % Convert magnitude to decibels if necessary
        if decibels
            magnitude = 20*log10(magnitude);
        end
        % Identify phase response
        phase = angle(Xf);
        % Identify corresponding frequencies [-0.5, 0.5]
        f = [0:N-1]/N;
        f = f - 0.5;
        % Create a figure in which frequency response will be plotted
        figure_handle = SPX_Figures.full_screen_figure;
        % Create a sub plot for magnitude response
        subplot(211);
        % Identify the range of magnitude values
        maxValue = max(magnitude);
        minValue = min(magnitude);
        % Plot frequency vs magnitude
        plot(f, magnitude);
        hold on;
        grid;
        hold off;
        xlabel('Frequency');
        % Provide some extra spacing on x axis.
        set(gca, 'xlim', [-0.55, 0.55]);
        % Assign label to y axis 
        if decibels
            ylabel('Magnitude (dB)');
            set(gca, 'ylim', [max(maxValue - 100, minValue), maxValue+ 5]);
        else
            ylabel('Magnitude');
        end
        title('Magnitude response');

        % Now create a subplot for phase response.
        subplot(212);
        plot(f, phase);
        grid;
        xlabel('Frequency');
        ylabel('Phase (Radians)');
        set(gca, 'xlim', [-0.55, 0.55]);
        title('Phase response');
    end


    function [ figure_handle ] = rational_poles_zeros( b,a)
        % Plots the poles and zeros of a rational filter

        % Zeros from B(z)
        zeros = roots(b);
        % Poles from A(z)
        poles = roots(a);
        % Points on the unit circle in complex plane
        N = 2000;
        unit_circle = exp(2*pi*j*[0:N]/N);
        % Create a full screen figure 
        figure_handle = SPX_Figures.full_screen_figure;
        % We draw the unit circle
        plot(unit_circle);
        % Actually the command above, plots real part and
        % imaginary part of unit_circle on x and y axes 
        % respectively.
        hold on;
        % We draw the zeros in green
        plot(zeros, 'kx', 'MarkerSize', 10, 'LineWidth',2);
        grid;
        % We draw the poles in red
        plot(poles, 'rx', 'MarkerSize', 10, 'LineWidth',2);
        axis square;
        legend('Unit circle', 'Zeros', 'Poles');
        title('Poles and Zeros of H(z)= B(z)/A(z)');
    end


    function [figure_handle] = polyhedron(A, b, span)
        % Plots the lines for a polyhedron given by Ax = b
        % in the region given by span.
        % span = [XMin, XMax, YMin, YMax]
        [num_lines , dimension]  = size(A);
        if dimension ~= 2
            error('Only polyhedrons in 2 d space are supported.');
        end
        XMin = span(1);
        XMax = span(2);
        YMin = span(3);
        YMax = span(4);
        x_min = min(XMin, YMin);
        x_max = max(XMax, YMax);
        % Identify the range of x values for which points will be computed.
        range  = x_max - x_min;
        x_min = x_min - range / 2;
        x_max = x_max + range / 2;
        x = linspace(x_min,x_max);

        % Create a full screen figure 
        figure_handle = SPX_Figures.full_screen_figure;
        hold on;
        for i=1:num_lines
            a = A(i, :);
            % the equation of line is given by a'x = b
            % => a1 * x1 + a2 * x2 = b
            % => x2 = -a1*x1 / a2 + b/a2
            plot( x, -x*a(1)./a(2) + b(i)./a(2),'b-');
        end
        xlabel('x_1');
        ylabel('x_2');
        % the range of axes [XMin, XMax, YMin, YMax]
        axis(span);
        % We want to make sure that both axes are equal scale
        axis square;
    end

end


end


