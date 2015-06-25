function env = spx_get_env();
    global spx_env;
    if isempty(spx_env)
        filepath = which(mfilename); 
        root = fileparts(filepath);
        spx_settings_cache = fullfile(root, 'spx_local_settings.mat');
        data = load(spx_settings_cache);
        spx_env = data.globals;
    end
    env = spx_env;
end

