classdef core
% General utility functions
methods(Static)


function result = is_class(classpath)
    % Returns true if classpath points to a MATLAB class.
    result = (exist(classpath, 'class') ~= 0);
end

function result = yes_no(flag)
    if flag == 0
        result = 'No';
    else
        result = 'Yes';
    end
end

function result = true_false(flag)
    if flag == 0
        result = 'false';
    else
        result = 'true';
    end
end

function result = true_false_short(flag)
    if flag == 0
        result = 'F';
    else
        result = 'T';
    end
end

function result = success_failure(flag)
    if flag == 0
        result = 'Failure';
    else
        result = 'Success';
    end
end

function result = success_failure_short(flag)
    if flag == 0
        result = 'F';
    else
        result = 'S';
    end
end

function result = plot_styles()
    result = {...
    '--+','-.o',':*',...
    '--.','-.x',':s',...
    '--d','-.^',':v',...
    '-->','-.<',':p',...
    '--h'};
end
    
end

end

