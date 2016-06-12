classdef SPX_Lang
% Useful methods for extending Language core functionality

methods(Static)
    
    function varargout = noop(varargin)
        % Does nothing
        for i=1:nargout
            varargout{i} = [];
        end
    end

end

end
