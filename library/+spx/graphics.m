classdef graphics

methods(Static)

    function result = plot_styles()
        % plot styles for multiple plots
        result = {...
        '--+','-.o',':*',...
        '--.','-.x',':s',...
        '--d','-.^',':v',...
        '-->','-.<',':p',...
        '--h'};
    end

end

end