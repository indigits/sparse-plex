classdef SSC_NN_OMP < handle
    % Implements sparse subspace clustering algorithm using OMP algorithm
    properties
        Quiet = false
    end


    properties(SetAccess=private)
        % Dimension of signal space
        N
        % Number of signals in the space
        S
        % A matrix of size NxS where each column is one signal vector
        Data
        % data vectors after normalization
        NormalizedData
        % The sparsity level or the largest dimension of the sparse subspaces
        K
        % The expected number of subspaces
        NumSubspaces
        % Labels obtained through clustering
        Labels
        % Representation matrix (each column is a representation vector for one data vector)
        Representation
        % affinities identified during sparse coding
        Affinity
        % Adjacency matrix
        Adjacency
        % The spectral clusterer used in the algorithm
        Clusterer
    end

    methods
        function self = SSC_NN_OMP(X, K, NumSubspaces)
            % Constructor
            self.Data = X;
            self.K = K;
            if nargin < 3
                NumSubspaces = -1;
            end
            self.NumSubspaces = NumSubspaces;
            [n, s] = size(X);
            self.N = n;
            self.S = s;
            self.Labels = ones(s, 1);
            % Each data vector is represented using other data vectors in same space
            self.Representation = zeros(s, s);
            self.Affinity = zeros(s, s);
        end

        function result = solve(self)
            % prepare sparse representations
            self.recover_coefficients();
            self.build_adjacency();
            clusterer = spx.cluster.spectral.Clustering(self.Adjacency);
            % keep reference for debugging purposes.
            self.Clusterer = clusterer;
            clusterer.NumClusters = self.NumSubspaces;
            cluster_labels = clusterer.cluster_random_walk();
            self.Labels = cluster_labels;
            % Return the labels
            result.Labels = self.Labels;
        end

    end

    methods(Access=private)

        function recover_coefficients(self)
            % Computes sparse representations of the data vectors
            data = self.Data;
            self.NormalizedData = spx.commons.norm.normalize_l2(data);
            % Number of data vectors
            ns = self.S;
            % iterate over signals
            all_cols = 1:ns;
            for s=all_cols
                if ~self.Quiet 
                    fprintf('.');
                    if mod(s, 50) == 0
                        fprintf('\n');
                    end
                end
                self.nn_omp(s);
            end
            if ~self.Quiet 
                fprintf('\n');
            end
        end

        function nn_omp(self, s)
            % Apply nearest neighbor OMP on s-th vector.
            % data matrix
            X = self.NormalizedData;
            % Current vector
            x =X(:, s);
            % number of vectors
            ns = self.S;
            % Subspace dimension
            nk = self.K;
            % current residual
            r = x;
            % ambient dimension
            nd = self.N;
            % coefficients
            z  = zeros(ns, 1);
            % affinities
            c = zeros(ns, 1);
            % selected indices
            omega = [];
            % max number of iterations
            maxIter = nk;
            MaxResNorm = 1e-4;
            for iter=1:maxIter
                % Compute inner products
                innerProducts = X' * r;
                innerProducts(s) = 0;
                innerProducts(omega) = 0;
                innerProducts = abs(innerProducts);
                % Find the highest inner product
                [~, indices] = sort(innerProducts, 'descend');
                index = indices(1);                % Add this index to support
                omega = [omega, index];

                c(indices(1:nk)) = innerProducts(indices(1:nk));
                % Solve least squares problem
                subdict = X(:, omega);
                tmp = linsolve(subdict, x);
                % Updated solution
                z(omega) = tmp;
                % Let us update the residual.
                r = x - subdict * tmp;
                resNorm = norm(r);
                if resNorm < MaxResNorm
                    break;
                end
            end
            self.Representation(:, s) = z;
            self.Affinity(:, s) = c;
        end

        function detect_outliers(self)
            % Identifies outliers in the representations
        end

        function build_adjacency(self)
            C = abs(self.Affinity);
            % Normalize the matrix by column wise maximums
            C = spx.commons.norm.normalize_linf(C);
            % Make it symmetric
            C = C + C';
            % Keep it
            self.Adjacency = C;
        end

    end

end

