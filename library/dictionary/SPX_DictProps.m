classdef SPX_DictProps < handle
% Defines various properties of a dictionary
% See
% - 2011_learned_dictionaries_for_sparse_image_representation_properties_and_results.pdf
% - 
    properties(Access=private)
        % The dictionary matrix
        Dict = []
        Gram = []
        AbsGram = []
        Frame = []
        SingularValues = []
        % Signal space dimension
        N
        % Number of atoms
        D
        % Coherence
        Coherence = []
    end

    methods
        function self = SPX_DictProps(Dict)
            if isa(Dict, 'SPX_Operator')
                self.Dict = double(Dict);
            elseif ismatrix(Dict)
                self.Dict = Dict; 
            else
                error('Unsupported dictionary.');
            end
            [self.N, self.D] = size(self.Dict);
        end

        function result = gram_matrix(self)
            if isempty(self.Gram)
                d = self.Dict;
                self.Gram = d' * d;
            end
            result = self.Gram;
        end

        function result = abs_gram_matrix(self)
            if isempty(self.AbsGram)
                g = self.gram_matrix();
                self.AbsGram = abs(g);
            end
            result = self.AbsGram;
        end

        function result = frame_operator(self)
            if isempty(self.Frame)
                d = self.Dict;
                self.Frame = d * d';
            end
            result = self.Frame;
        end

        function result = singular_values(self)
            if isempty(self.SingularValues)
                [U, S, V] = svd(self.Dict);
                self.SingularValues = diag(S)';
            end
            result = self.SingularValues;
        end

        function result = gram_eigen_values(self)
            % Returns the eigen values of the Gram matrix
            % They are same for frame operator
            % sum = D
            s = self.singular_values();
            result = s.^2;
        end

        function result = lower_frame_bound(self)
            lambda = self.gram_eigen_values();
            result = lambda(end);
        end

        function result = upper_frame_bound(self)
            lambda = self.gram_eigen_values();
            result = lambda(1);
        end

        function result = coherence(self)
            if isempty(self.Coherence)
                absG = self.abs_gram_matrix();
                absG(logical(eye(size(absG)))) = 0;
                [mu, index] = max(absG(:));
                self.Coherence = mu;
            end
            result = self.Coherence;
        end
    end
end
