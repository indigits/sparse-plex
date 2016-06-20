function locate_examples()
    % Changes current directory to the folder containing spx.
    root = spx.root_dir;
    lib = fileparts(root);
    examples = fullfile(lib, 'examples');
    cd (examples);
end
