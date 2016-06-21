classdef SSC_L1 < handle
    % Implements sparse subspace clustering algorithm.
    % See 2013_sparse_subspace_clustering_algorithm_theory_applications.pdf

    

    properties
        Quiet = false
        Affine = false
        NoiseFactor = 0.01
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
    end

    methods
        function self = SSC_L1(X, K, NumSubspaces)
            % Constructor
            self.Data = X;
            self.K = K;
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

            % conduct spectral clustering
            options.num_clusters = self.NumSubspaces;
            result = spx.cluster.spectral.simple.normalized_symmetric(self.Adjacency, options);
            cluster_labels = result.labels;


            % We are disabling our version of spectral clustering for now.            
            %clusterer = spx.cluster.spectral.Clustering(self.Adjacency);
            %clusterer.NumClusters = self.NumSubspaces;
            %cluster_labels = clusterer.cluster_random_walk();

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
                % the signal dictionary to be used for reconstruction
                cols = all_cols ~= s; % S - 1 columns
                % dimensions are D x (S - 1)
                A = data(:, cols);
                % threshold for the noise norm
                noise_norm_threshold = self.NoiseFactor * norm(x);
                if self.Affine
                    cvx_begin quiet;
                        cvx_precision high;
                        variable rep(ns-1,1);
                        minimize( norm(rep,1) );
                        subject to
                            norm(A * rep  - x) <= noise_norm_threshold;
                            sum(rep) == 1;
                    cvx_end;
                else
                    cvx_begin quiet;
                        cvx_precision high;
                        variable rep(ns-1,1);
                        minimize( norm(rep,1) );
                        subject to
                            norm(A * rep  - x) <= noise_norm_threshold;
                    cvx_end;
                end
                % Prepare the l1 solver
                % solver = spx.pursuit.single.BasisPursuit(A, x);
                % solver.Quiet = true;
                % lambda = 2.5;
                % Run the solver to obtain sparse representation
                % rep = solver.solve_l1_noise();
                % The obtained representation is in R^{S - 1} dimensions

                % Put back the representation
                self.Representation(cols, s) = rep;
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

