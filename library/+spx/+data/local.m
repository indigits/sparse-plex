classdef local

methods(Static)

    function root_dir = yale_faces_dir()
        % This should be changed to whatever place the faces are maintained.
        % The changes need to be done in ``spx_local.ini`` file.
        % Alternative is to subclass this class and override this method.
        env = spx_get_env();
        root_dir = env.local_settings.yale_faces_db_dir;
    end

end

end
