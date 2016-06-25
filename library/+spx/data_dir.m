function result = data_dir()
    root = spx.root_dir;
    parent = fileparts(root);
    result = [parent filesep 'data'];
end
