classdef SSC_MC_OMP < handle
    % Implements sparse subspace clustering algorithm using OMP algorithm
    properties
        Quiet = false
        % The branching factor
        BranchingFactor = 2
        MaxCandidatesToRetain = 10
    end


    properties(SetAccess=private)
        % Dimension of signal space
        N
        % Number of signals in the space
        S
        % A matrix of size NxS where each column is one signal vector
        Data
        % The sparsity level or the largest dimension of the sparse subspaces
        K
        % The expected number of subspaces
        NumSubspaces
        % Labels obtained through clustering
        Labels
        % Representation matrix (each column is a representation vector for one data vector)
        Representation
        % Adjacency matrix
        Adjacency
        % The spectral clusterer used in the algorithm
        Clusterer
        % Threshold for residual norm
        ResidualNormThreshold
        % Number of iterations for each vector
        Iterations
    end

    methods
        function self = SSC_MC_OMP(X, K, NumSubspaces, ResidualNormThreshold)
            % Constructor
            self.Data = X;
            self.K = K;
            if nargin < 3
                NumSubspaces = -1;
            end
            self.NumSubspaces = NumSubspaces;
            if nargin < 4
                ResidualNormThreshold = 1e-3;
            end
            self.ResidualNormThreshold = ResidualNormThreshold;
            [n, s] = size(X);
            self.N = n;
            self.S = s;
            self.Labels = ones(s, 1);
            % Each data vector is represented using other data vectors in same space
            self.Representation = zeros(s, s);
        end

        function result = solve(self)
            % prepare sparse representations
            tstart = tic;
            self.recover_coefficients();
            representation_time = toc(tstart);
            self.build_adjacency();

            % conduct spectral clustering
            tstart = tic;
            result = spx.cluster.spectral.simple.normalized_symmetric_sparse(self.Adjacency, self.NumSubspaces);
            cluster_labels = result.labels;
            result.clustering_time = toc(tstart);
            % We are disabling our version of spectral clustering for now.            
            % clusterer = spx.cluster.spectral.Clustering(self.Adjacency);
            % keep reference for debugging purposes.
            % self.Clusterer = clusterer;
            % clusterer.NumClusters = self.NumSubspaces;
            % cluster_labels = clusterer.cluster_random_walk();            
            self.Labels = cluster_labels;
            result.Z = self.Representation;
            result.W = self.Adjacency;
            result.representation_time = representation_time;
        end

    end

    methods(Access=private)


        function detect_outliers(self)
            % Identifies outliers in the representations

        end

        function build_adjacency(self)
            C = abs(self.Representation);
            % Normalize the matrix by column wise maximums
            C = spx.norm.normalize_linf(C);
            % disp(C(:, 1));
            % Make it symmetric
            C = C + C';
            % Keep it
            self.Adjacency = C;
            % disp(self.Adjacency(:, 1));
        end

    end

end

