classdef DictionaryLearningFramework < handle
% Core framework for dictionary learning
% Should be subclassed to implement specific learning algorithms.

properties
    % Maximum number of iterations to perform
    MaxIterations = 50
    % Optional initial dictionary if specified the iterations will
    % start from here.
    InitialDictionary = []
    % Allowed maximum sparsity level of signal
    % if 0 then arbitrary sparsity level is allowed
    K = 0
    % Maximum representation error allowed 
    % if 0 then go by fixed sparsity level
    MaxError = 0
    % Special atoms. They are never removed or modified.
    SpecialAtoms = []
    % Dictionary Update Tracker
    Tracker
    % OMP parameters
    StopOnResidualNorm = false
    StopOnResNormStable = false

end

properties(SetAccess=protected)
    % Number of dictionary elements to train
    D
    % Signal space dimension
    N
    % Learnt dictionary
    Dict
    % Number of iterations the algorithm ran
    Iterations = 0
    % Unused atoms
    UnusedAtoms
    % Too close atoms
    CloseAtoms
    % Replaced atoms
    ReplacedAToms    
    % K-SVD-CC related stuff
    % atom updates which were rejected due to coherence constraint
    RejectedUpdates = 0;
    % atom updates which were accepted within coherence constraint
    AcceptedUpdates = 0;
    
end

properties(GetAccess=protected,SetAccess=protected)
    % Data on which to operate
    X
    % Column wise norms of data
    XNorms
    % Number of signals
    S
    % Current representation
    Alpha
    % Current residual
    R
    % counter for storing iteration data
    counter
    % Indicates if we should stop now
    stopIterations = false
end


methods
    function self = DictionaryLearningFramework(D, N)
        self.D = D;
        self.N = N;
    end

    function self = train(self, X)
        d = self.D;
        n = self.N;
        if size(X, 1) ~= n
            error('Invalid data');
        end
        % Data for use in other helper functions
        self.X = X;
        self.XNorms = spx.norm.norms_l2_cw(X);
        % Number of signals
        self.S = size(X,2);
        % Initialize storage counter.
        self.counter = 1;
        if self.InitialDictionary
            dict = self.InitialDictionary(1:n, 1:d);
        else
            % We pick first d elements from X
            % as our atoms
            dict = X(:,1:d);
        end
        % normalize the dictionary
        dict = spx.norm.normalize_l2(dict);
        self.Dict = dict;
        % Initialize representation
        self.update_representations();
        if ~isempty(self.Tracker)
            self.Tracker(self.Dict, self.Alpha, self.R);
        end
        % A flag which can be signaled from any part of code
        % to stop further learning.
        self.stopIterations = false;
        for iter=1:self.MaxIterations
            self.counter = self.counter + 1;
            self.update_dictionary();
            self.clean_dictionary();
            self.update_representations();
            if ~isempty(self.Tracker)
                self.Tracker(self.Dict, self.Alpha, self.R);
            end
            if self.stopIterations
                break;
            end
        end
        self.Iterations  = iter;
    end
end

methods(Access=protected)
    function update_representations(self)
        % We now create sparse representations
        omp = spx.pursuit.single.OrthogonalMatchingPursuit(self.Dict, self.K);
        omp.StopOnResidualNorm = self.StopOnResidualNorm;
        omp.StopOnResNormStable = self.StopOnResNormStable;
        % Solve all sparse approximation problems
        result = omp.solve_all_linsolve(self.X);
        % Get the sparse representations
        self.Alpha = result.Z;
        self.R = result.R;
        c  = self.counter;
    end
    
    function update_dictionary(self)
        error('Should be implemented by subclass.');
    end
    

end

methods(Access=private)
    
    function clean_dictionary(self)
        % Removes atoms which are rarely used or too close
        dict = self.Dict;
        alpha = self.Alpha;
        % compute gram matrix
        [muBeforeCleanup, ~, ~, gram] =  spx.dict.Properties(dict).coherence_with_index();
        % Number of atoms
        d = self.D;
        % If inner product crosses this threshold then the atoms are
        % very similar.
        T2 = 0.99;
        residual = self.X - dict * alpha;
        errorEnergy = spx.commons.snr.energies(residual);
        [errorEnergy, sigPositions] = sort(errorEnergy, 'descend');
        c = self.counter;
        totalError = sqrt(sum(sum(residual.^2))/numel(residual));
        fprintf('Iteration: %d, Error before cleanup=%f\n'...
            , c - 1,totalError);

        %normalizedErrorEnergy = errorEnergy ./ self.XNorms;
        % Indicates if the dictionary was updated
        updates = 0;
        unusedAtoms = 0;
        closeAtoms  = 0;
        for j=1:d
            if any(self.SpecialAtoms == j)
                % We will not change this atom
                continue;
            end
            % whether the atom will be replaced or not
            replaceAtom = false;
            % j-th atom's inner product with others
            ip = gram(j, :);
            % maximum inner product
            [ipmax, ~] = max(ip);
            if ipmax >= T2
                replaceAtom = true;
                closeAtoms = closeAtoms + 1;
            else
                % find entries for this atom 
                entries = alpha(j,:);
                % identify entries which have significant value
                significantEntries = find(abs(entries) > 1e-7);
                if length(significantEntries) < 3
                    % This atom contributes to very few signals
                    replaceAtom = true;
                    unusedAtoms = unusedAtoms + 1;
                end
            end
            if replaceAtom
                % Find out the signal with maximum representation error
                for s=1:self.S
                    if errorEnergy(s) == 0
                        continue;
                    end
                    signalIndex = sigPositions(s);
                    if 1
                        fprintf('Replacing atom: %d with signal %d: ', j, signalIndex);
                    end
                    % We are going to pick up this signal and replace in
                    % dictionary
                    x = self.X(:, signalIndex);
                    x = x / norm(x);
                    % Now we wish to check if this signal is going to
                    % mess up the coherence level of the dictionary
                    sigInnerProducts = x' * dict;
                    sigCoherence = max(abs(sigInnerProducts));
                    if sigCoherence >= muBeforeCleanup
                        % This signal will increase dictionary coherence
                        % we don't want to do this. 
                        %continue;
                    end
                    % replace atom
                    dict(:, j) = x;
                    % update gram matrix
                    [~, ~, ~, gram] =  spx.dict.Properties(dict).coherence_with_index();
                    updates = updates + 1;
                    % We won't use this signal as replacement later
                    errorEnergy(s) = 0;
                    break;
                end
            end
        end
        if updates
            % update the dictionary
            self.Dict = dict;
            fprintf('Number of atoms replaced: %d, (close: %d, unused: %d) \n',... 
            updates, closeAtoms, unusedAtoms);
        end
        % Lets measure the coherence of dictionary
        [muAfterCleanup, i, j] = spx.dict.Properties(dict).coherence_with_index();
        self.UnusedAtoms(c) = unusedAtoms;
        self.CloseAtoms(c) = closeAtoms;
        self.ReplacedAToms(c) = unusedAtoms + closeAtoms; 
        fprintf('Dictionary coherence before cleanup: %0.03f', muBeforeCleanup);
        fprintf(' after cleanup between(%d %d): %0.03f, \n', i, j, muAfterCleanup);
        if muAfterCleanup > muBeforeCleanup
            warning('Coherence increased\n');
        end
    end
    
end


end
