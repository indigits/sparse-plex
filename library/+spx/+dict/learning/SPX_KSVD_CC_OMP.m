classdef SPX_KSVD_CC_OMP < SPX_DictionaryLearningFramework

methods

    function self = SPX_KSVD_CC_OMP(D, N)
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
        % Lets measure the coherence of current dictionary
        mu = spx.dict.Properties(dict).coherence();
        % Let us iterate atom by atom
        rejected = 0;
        accepted = 0;
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
            % Lets compute the coherence of new atom with existing
            % dictionary atoms
            coherences = abs(betterAtom' * dict);
            coherences(i) = 0;
            maxCoherence = max(coherences);
            if maxCoherence > mu
                % This new atom will increase the coherence of
                % dictionary. Hence we will reject it.
                rejected = rejected + 1;
                continue;
            end
            % Update the atom in dictionary dictionary
            dict(:,i) = betterAtom;
            % Update the representations
            alpha(i, relevantSignalIndices) = singularValue*betaVector';
            accepted = accepted + 1;
        end
        % SVD gives normalized atoms only
        % Store for next iterations.
        self.Dict = dict;
        % Updated representation.
        self.Alpha = alpha;
        self.RejectedUpdates = self.RejectedUpdates + rejected;
        self.AcceptedUpdates = self.AcceptedUpdates + accepted;
        fprintf('%d updates rejected and %d updates accepted.\n',...
            rejected, accepted);
    end

end

end
