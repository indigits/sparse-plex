classdef SPX_SparseRepClustering < handle
    % Implements sparse representation clustering algorithm.
    % Input: Representations of a set of signals in a known dictionary.
    % Output: Clustering of signals

    

    properties
        SpectralKMeansMaxIter = 1000
        SpectralKMeansReplications = 5
        Debug = false
    end


    properties(SetAccess=private)
        % Dimension of representation space
        N
        % Number of signals in the space
        S
        % A matrix of size NxS where each column is one signal representation vector
        Data
        % The sparsity level or the largest dimension of the sparse subspaces
        K
        % The expected number of subspaces (could be unknown)
        NumExpectedSubspaces
        % Number of subspaces found
        NumFoundSubspaces = -1
        % Labels obtained through clustering
        Labels
        % Adjacency matrix
        Adjacency
        % The spectral clusterer
        Spectral
    end

    methods
        function self = SPX_SparseRepClustering(X, K, NumExpectedSubspaces)
            % Constructor
            if nargin < 3
                NumExpectedSubspaces = -1;
            end
            if nargin < 2
                K = -1;
            end
            self.Data = X;
            self.K = K;
            self.NumExpectedSubspaces = NumExpectedSubspaces;
            [n, s] = size(X);
            self.N = n;
            self.S = s;
            self.Labels = ones(s, 1);
        end

        function result = solve(self)
            % prepare sparse representations
            self.build_adjacency();
            clusterer = SPX_SpectralClustering(self.Adjacency);
            clusterer.Debug = self.Debug;
            self.Spectral = clusterer;
            clusterer.MAXiter = self.SpectralKMeansMaxIter;
            clusterer.Replications  = self.SpectralKMeansReplications;
            clusterer.NumClusters = self.NumExpectedSubspaces;
            cluster_labels = clusterer.cluster_random_walk();
            if self.Debug
                cluster_labels'
            end
            self.Labels = cluster_labels;
            self.NumFoundSubspaces = max(cluster_labels);
            % Return the labels
            result.Labels = self.Labels;
            result.NumClusters = self.NumFoundSubspaces;
        end

    end

    methods(Access=private)

        function detect_outliers(self)
            % Identifies outliers in the representations
        end

        function build_adjacency(self)
            C = abs(self.Data); % N x S
            % Normalize the matrix by column wise norms
            C = spx.commons.norm.normalize_l2(C);
            % Compute inner product of signals with each other
            innerProducts  = C' * C; % S x S.
            % Since the signals are normalized, hence inner products are guaranteed to be 
            % in the range of (0, 1)
            % They can be used as similarity measurements.
            % Keep it
            self.Adjacency = innerProducts;
        end

    end

end

