function [globals] = spx_setup()
% Let us get the full path of this file
globals.filepath = which(mfilename);
% Get the directory of this file
% This is the directory in which SparsePlex library is hosted.
globals.root = fileparts(globals.filepath);
% This is the directory where source-plex library code is hosted.
globals.spx = fullfile(globals.root, 'library');


addpath(globals.root);
addpath(globals.spx);
globals.ext = fullfile(globals.spx, 'ext');
addpath(globals.ext);
% support for spx_ini2struct function
addpath(fullfile(globals.ext, 'ini2struct'));





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Following process is for getting the default settings
% for different data directories in local environment.
default_settings_path = fullfile(globals.root, 'spx_defaults.ini');
local_settings_path = fullfile(globals.root, 'spx_local.ini');
if ~exist(local_settings_path, 'file')
    fprintf('Copying default settings file to local settings file.\n');
    copyfile(default_settings_path, local_settings_path);
end
globals.local_settings = spx_ini2struct(local_settings_path);
spx_settings_cache = fullfile(globals.root, 'spx_local_settings.mat');
save(spx_settings_cache, 'globals');
end

