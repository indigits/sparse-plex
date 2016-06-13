classdef SparseRecoveryProblemDescription < handle

    properties
        Dict
        Phi
        Representations
        Signals
        Measurements
        D
        M
        N
        % Sparsity level
        K
        % Number of signals
        S
        DictionaryType
        SensingMatrixType
        SignalType
        % Number of subspaces
        NumSubspaces = -1 % unknown
        NumSignalsPerSubspace = -1 % unknown
    end

    methods
        function self = SparseRecoveryProblemDescription(Dict, Phi, K, ...
            Representations, Signals, Measurements)
            if isstruct(Dict)
                % This looks like a problem defined in 
                % SPX_RecoveryProblems
                problem = Dict;
                Dict = [];
                if isfield(problem, 'dictionary')
                    Dict = problem.dictionary;
                end
                Phi = [];
                K = -1;
                if isfield(problem, 'sparsity_level')
                    K = problem.sparsity_level;
                end
                Representations = [];
                if isfield(problem, 'representation_vector')
                    Representations = problem.representation_vector;
                end
                Signals = [];
                if isfield(problem, 'signal_vector')
                    Signals = problem.signal_vector;
                end
                Measurements = [];
            end
            self.Dict = Dict;
            self.Phi = Phi;
            self.K  = K;
            self.Representations = Representations;
            self.Signals = Signals;
            self.Measurements = Measurements;
            if ~isempty(Dict)
                [N, D] = size(Dict);
                self.D = D;
                self.N = N;
            end
            if ~isempty(Phi)
                [M, N] = size(Phi);
                self.M = M;
                self.N  = N;
            end
            if ~isempty(Representations)
                self.S = size(Representations, 2);
            end
            if ~isempty(Signals)
                self.S = size(Signals, 2);
            end
            if ~isempty(Measurements)
                self.S = size(Measurements, 2);
            end
        end

        function describe(self)
            if self.D ~= 0
                fprintf('Representation dimension: %d\n', self.D);
            end
            if self.N ~= 0
                fprintf('Signal dimension: %d\n', self.N);
            end
            if self.M ~= 0
                fprintf('Measurement dimension: %d\n', self.M);
            end
            if self.K ~= 0
                fprintf('Sparsity level: %d\n', self.K);
            end
            if self.S ~= 0
                fprintf('Number of signals: %d\n', self.S);
            end
            if self.NumSubspaces > 0
                fprintf('Number of subspaces: %d\n', self.NumSubspaces);
            end
            if self.NumSignalsPerSubspace > 0
                fprintf('Signals per subspace: %d\n', self.NumSignalsPerSubspace);
            end
            if ~isempty(self.DictionaryType)
                fprintf('Dictionary type: %s\n', self.DictionaryType);
            end
            if ~isempty(self.SignalType)
                fprintf('Signal type: %s\n', self.SignalType);
            end
        end

    end



end
