function result = cache_dir()
    root = spx.root_dir;
    result = [root filesep 'cache'];
    % Create the directory for storing images
    [status_code,message,message_id] = mkdir(result);
end
