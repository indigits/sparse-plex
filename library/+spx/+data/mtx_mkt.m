% Wrapper for files from matrix market
classdef mtx_mkt

methods(Static)

function A = abb313()
    A = read_file('abb313.mtx');
end

function A = illc1850()
    A = read_file('illc1850.mtx');
end

function A = matrix(name)
    filename = [name '.mtx'];
    A = read_file(filename);
end

end

end

function A = read_file(filename)
    filepath = fullfile(spx.data_dir, 'matrix_market', filename);
    A = mmread(filepath);
end

