classdef SPX_KSVD_OMP < SPX_DictionaryLearningFramework

methods

    function self = SPX_KSVD_OMP(D, N)
        % Constructor

        % Call super class constructor
        self@SPX_DictionaryLearningFramework(D, N);
    end

end

methods(Access=protected)

    function update_dictionary(self)
        % Current representations
        alpha = self.Alpha;
        % Current dictionary
        dict = self.Dict;
        % Number of atoms
        d = self.D;
        X1 = self.X;
        % Let us iterate atom by atom
        for i=1:d
            if any(self.SpecialAtoms == i)
                % We will not change this atom
                continue;
            end
            % Find the signals which use this atom
            relevantSignalIndices = find(alpha(i, :));
            % pick up those representations
            relevantAlphas = alpha(:, relevantSignalIndices);
            % We wish to update this atom for all relevant signals
            % first reset contribution from this atom
            relevantAlphas(i, :) = 0;
            relevantX = X1(:, relevantSignalIndices);
            % Compute the error
            errors = relevantX - dict*relevantAlphas;
            % Find the first singular value and corresponding vectors
            [betterAtom,singularValue,betaVector] = svds(errors,1);
            % Update the atom in dictionary dictionary
            dict(:,i) = betterAtom;
            % Update the representations
            alpha(i, relevantSignalIndices) = singularValue*betaVector';
        end
        % SVD gives normalized atoms only
        % Store for next iterations.
        self.Dict = dict;
        % Updated representation.
        self.Alpha = alpha;
    end
end

end

