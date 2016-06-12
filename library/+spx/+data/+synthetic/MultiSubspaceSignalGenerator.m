classdef MultiSubspaceSignalGenerator < handle
    %MultiSubspaceSignalGenerator creates sparse signals
    % Usage:
    %   - Create generator with ambient dimension N and sparsity level K
    %   - Design the support for subspaces
    %   - Specify number of signals for each subspace
    %   - Generate signals for each subspace
    properties(SetAccess=private)
        % The ambient signal dimension
        N 
        % The sparsity level
        K
        % The resultant vectors
        X
        % The Sparse support for each subspace
        Supports
        % The number of signals in each Subspace
        NumSignalsPerSubspace = []
        % Labels identify the subspace to which a signal belongs
        Labels = []
    end
    
    methods
        function self = MultiSubspaceSignalGenerator(N, K)
            self.N = N;
            self.K = K;
        end
        
        function createDisjointSupports(self, numSubspaces)
            n = self.N;
            k  = self.K;
            c = numSubspaces;
            if c*k > n
                error('Total cardinality of subspaces cannot exceed ambient dimensions');
            end
            % Select c*k indices randomly from 1:N
            q = randperm(n, c*k);
            % Arrange the support for each subspace.
            self.Supports = sort(reshape(q, k, c));
            % By default we will create one signal per subspace
            self.NumSignalsPerSubspace = ones(numSubspaces, 1);
        end
        
        function createOverlappingSupports(self, numSubspaces, overlap)
            % Overlap specifies number of indices which overlap between
            % two consecutive supports.
            n = self.N;
            k  = self.K;
            c = numSubspaces;
            l = c*(k-overlap)+overlap;
            if  l > n
                error('Total cardinality of subspaces cannot exceed ambient dimensions, n=%d, l=%d', n, l);
            end
            % Select l indices randomly from 1:N
            q = randperm(n, l);
            % Arrange the support for each subspace.
            qs = zeros(k,c);
            start = 0;
            for i=1:c
                qs(:, i) = q(start + (1:k));
                start = start + k - overlap;
            end
            self.Supports = sort(qs);
            % By default we will create one signal per subspace
            self.NumSignalsPerSubspace = ones(numSubspaces, 1);
        end
        
        function setNumSignalsPerSubspace(self, numSignalsPerSubspace)
            c = length(self.NumSignalsPerSubspace);
            data = numSignalsPerSubspace;
            if isscalar(data)
                self.NumSignalsPerSubspace = data *ones(c, 1);
                return;
            end
            % Verify that numSignalsPerSubspace has appropriate size
            if length(data) ~= c
                error('Number of subspaces mismatch');
            end
            % Make sure its a column vector
            if isrow(data)
                data = data';
            end
            % save it
            self.NumSignalsPerSubspace = data;
        end
        
        function result = uniform(self, a,b)
            % Generates sparse signals from uniform distribution
            if nargin < 3
                a = 0; b =1;
            elseif nargin < 4
                b = -a;
            end
            if b <= a
                error('b must be larger than a');
            end
            % sparsity level
            k = self.K;
            % number of signals per subspace
            signalCounts = self.NumSignalsPerSubspace;
            % total number of signals
            totalSignals = sum(signalCounts);
            % Ambient dimensions
            n = self.N;
            % supports 
            qs = self.Supports;
            % Number of subspaces
            c = length(qs);
            % Create space for signals
            self.X = zeros(n, totalSignals);
            self.Labels = zeros(totalSignals, 1);
            % Iterate over subspaces
            start = 0;
            for i=1:c
                % support for this subspace
                q = qs(:, i);
                % number of signals
                s = signalCounts(i);
                % Generate signals
                xx = a + (b-a).*rand(k,s);
                % Assign into combined set
                self.X(q, start + (1:s)) = xx;
                self.Labels(start + (1:s)) = i;
                % update start for next set
                start = start + s;
            end
            % Store the results
            result = self.X;
        end
        
        function result = biUniform(self, a, b, zeroProbability)
            % Generates sparse vectors where each non-zero values
            % is picked up uniformly from the ranges
            % [-b, -a] and [a, b]
            if nargin < 3
                a = 1; b =2;
            elseif nargin < 4
                b = 2*a;
            end
            if a < 0 || b < 0
                error('a and b both must be +ve');
            end
            if b <= a
                error('b must be larger than a');
            end
            if ~exist('zeroProbability', 'var')
                zeroProbability = 0;
            end
            if zeroProbability > 1 || zeroProbability < 0
                error('zeroProbability must be in [0,1]');
            end
            % sparsity level
            k = self.K;
            % number of signals per subspace
            signalCounts = self.NumSignalsPerSubspace;
            % total number of signals
            totalSignals = sum(signalCounts);
            % Ambient dimensions
            n = self.N;
            % supports 
            qs = self.Supports;
            % Number of subspaces
            c = size(qs,2);
            % Create space for signals
            self.X = zeros(n, totalSignals);
            self.Labels = zeros(totalSignals, 1);
            % Iterate over subspaces
            start = 0;
            for i=1:c
                % support for this subspace
                q = qs(:, i);
                % number of signals
                s = signalCounts(i);
                % Generate signals
                % unsigned result
                xx = a + (b-a).*rand(k,s);
                % sign
                sgn = sign(randn(k,s));
                if zeroProbability
                    % We need to introduce some zeros in between
                    sgn = sgn .* binornd(1, 1 - zeroProbability, k, s);
                end
                % Assign into combined set
                self.X(q, start + (1:s)) = sgn .* xx;
                self.Labels(start + (1:s)) = i;
                % update start for next set
                start = start + s;
            end
            % Store the results
            result = self.X;
        end
    end
    
end

