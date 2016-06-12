function locate()
    % Changes current directory to the folder containing spx.
    dir = fileparts(fileparts(which('spx.locate')));
    cd (dir);
end