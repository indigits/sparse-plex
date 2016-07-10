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
        % Threshold for residual norm
        ResidualNormThreshold
        % Number of iterations for each vector
        Iterations
    end

    methods
        function self = SSC_OMP(X, K, NumSubspaces, ResidualNormThreshold)
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

        function recover_coefficients(self)
            % Computes sparse representations of the data vectors
            data_matrix = self.Data;
            data_matrix = spx.commons.norm.normalize_l2(data_matrix);
            % Number of data vectors
            ns = self.S;
            % sparsity level
            nk = self.K;
            % support set for each vector [one row for each vector]
            support_sets = ones(ns, nk);

            % termination vector
            % contains the number of iterations in each a particular vector was solved.
            % initially it is set to K
            % the moment residual norm reduces below the threshold
            % we mark it as finished and store the number of iterations
            % in this vector
            termination_vector = nk * ones(ns, 1);

            % the normalized data is the starting point of vector
            residual_matrix  = data_matrix;
            % threshold for squared norm of residual 
            threshold = self.ResidualNormThreshold^2;
            for iter=1:nk
                if ~self.Quiet 
                    fprintf('.');
                end
                % We correlated data with residual.
                % to do change this to handle cases where there are too many points to handle
                correlation_matrix = abs(self.Data' * residual_matrix); % S x M  times M x S = S x S
                % set all the diagonal entries (inner product with self) to zero.
                correlation_matrix(1:ns+1:end) = 0;
                % the inner product of a residual with each atom is stored along a column
                % we need to take maximum of each column to identity the best matching atom
                [~, best_match_indices] = max(correlation_matrix, [], 1);
                % we fill in the support set
                support_sets(:, iter) = best_match_indices;
                if (iter ~= nk)
                    % we need to compute residuals except for the last iteration.
                    % iterate for each data point
                    for s=1:ns
                        if termination_vector(s) == nk
                            % this vector requires more iterations.
                            % pick the vector
                            x = data_matrix(:, s);
                            % pick support for this vector
                            support_set = support_sets(s, 1:iter);
                            % pick atoms
                            submatrix = data_matrix(:, support_set);
                            % solve the least squares problem
                            r = x - submatrix * (submatrix \ x);
                            % put the new residual into residual matrix
                            residual_matrix(:, s) = r;
                            if sum(r.^2) < threshold
                                % The processing of this vector is complete
                                termination_vector(s) = iter;
                            end
                        end
                    end
                    % now check if processing for all vectors have been terminated
                    continuing = termination_vector == nk;
                    if sum(continuing) == 0
                        % all vectors have been terminated
                        break;
                    end
                end
            end
            % final computation of coefficients
            % the values of coefficients corresponding to support sets
            coefficients_matrix = zeros(ns, nk);
            % Creation of sparse representation matrix
            for s=1:ns
                % number of iterations for this vector
                k = termination_vector(s);
                support_set  = support_sets(s, 1:k);
                x = self.Data(:, s);
                % pick atoms from the unnormalized data matrix
                submatrix = self.Data(:, support_set);
                % solve the least squares problem
                coeff = submatrix \ x;
                % if (s == 1)
                %     disp(submatrix(1:10, :));
                %     disp(x(1:10));
                %     disp(coeff);
                % end
                % put the coefficients back into coefficients matrix
                coefficients_matrix(s, 1:k) = coeff';
            end

            % each column varies from 1 to ns
            % each row is just a repetition
            column_indices  = repmat((1:ns)', 1, nk);

            % the support set, column_indices and coefficients_matrix are combined to form
            % the representation matrix at the end of function as follows
            % the support set contains row number
            % the column_indices contains the column number
            % the values contains the value of the non-zero entry
            % ns, ns is the size of the sparse matrix.
            self.Representation = sparse( support_sets(:), column_indices(:), coefficients_matrix(:), ns, ns);
            self.Iterations = termination_vector;
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
            % disp(C(:, 1));
            % Make it symmetric
            C = C + C';
            % Keep it
            self.Adjacency = C;
            % disp(self.Adjacency(:, 1));
        end

    end

end

