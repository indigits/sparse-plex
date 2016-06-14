classdef SSC_OMP < handle
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
    end

    methods
        function self = SSC_OMP(X, K, NumSubspaces)
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
        end

        function result = solve(self)
            % prepare sparse representations
            self.recover_coefficients();
            self.build_adjacency();
            result = spx.cluster.spectral.simple.normalized_symmetric(self.Adjacency);
            cluster_labels = result.labels;

            % We are disabling our version of spectral clustering for now.            
            % clusterer = spx.cluster.spectral.Clustering(self.Adjacency);
            % keep reference for debugging purposes.
            % self.Clusterer = clusterer;
            % clusterer.NumClusters = self.NumSubspaces;
            % cluster_labels = clusterer.cluster_random_walk();

            
            self.Labels = cluster_labels;
            % Return the labels
            result.Labels = self.Labels;
            result.Z = self.Representation;
            result.W = self.Adjacency;
        end

    end

    methods(Access=private)

        function recover_coefficients(self)
            % Computes sparse representations of the data vectors
            data = self.Data;
            data = spx.commons.norm.normalize_l2(data);
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
                % s-th data vector
                x = data(:, s);
                % Prepare the l1 solver
                solver = spx.pursuit.single.OrthogonalMatchingPursuit(data, self.K);
                solver.Verbose = false;
                solver.IgnoredAtom = s;
                % Run the solver to obtain sparse representation
                result = solver.solve(x);
                % The obtained representation is in R^{S - 1} dimensions
                % Put back the representation
                self.Representation(:, s) = result.z;
            end
            if ~self.Quiet 
                fprintf('\n');
            end
        end

        function detect_outliers(self)
            % Identifies outliers in the representations

        end

        function build_adjacency(self)
            C = abs(self.Representation);
            % Normalize the matrix by column wise maximums
            C = spx.commons.norm.normalize_linf(C);
            % Make it symmetric
            C = C + C';
            % Keep it
            self.Adjacency = C;
        end

    end

end

