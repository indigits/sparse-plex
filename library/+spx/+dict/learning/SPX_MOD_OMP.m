classdef SPX_MOD_OMP < SPX_DictionaryLearningFramework

methods

    function self = SPX_MOD_OMP(D, N)
        % Constructor

        % Call super class constructor
        self@SPX_DictionaryLearningFramework(D, N);
    end

end

methods(Access=protected)

    function update_dictionary(self)
        alpha = self.Alpha;
        % Create a sparse perturbation matrix
        perturbation = 1e-7*speye(self.D);
        dict = self.X*alpha'*pinv(alpha*alpha'+...
                     perturbation);
        % Identify atoms which are very small
        sumDictElems = sum(abs(dict));
        zerosIdx = find(sumDictElems < eps);
        % Fill those columns with random atoms
        dict(:, zerosIdx) = randn(self.N, length(zerosIdx));
        % normalize atoms
        dict = spx.norm.normalize_l2(dict);
        % Store for next iterations.
        self.Dict = dict;
                 
    end

end

end
