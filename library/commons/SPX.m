classdef SPX
% General utility functions
methods(Static)

function result = is_directory(dirpath)
    % Returns if dirpath is a directory or not.
    result = exist(dirpath, 'dir') ~= 0;
end

function result = is_file_or_dir(filepath)
    % Returns true if filepath is either a file or a directory
    result = (exist(filepath, 'file') ~= 0);
end

function result = is_file(filepath)
    % Returns true if filepath is a file
    result = (exist(filepath, 'file') ~= 0) & (exist(filepath, 'dir') == 0);
end

function result = is_class(classpath)
    % Returns true if classpath points to a MATLAB class.
    result = (exist(classpath, 'class') ~= 0);
end
    
end

end

