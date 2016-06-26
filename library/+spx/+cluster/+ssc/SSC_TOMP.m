classdef SSC_TOMP < handle
    % Implements sparse subspace clustering algorithm using a tree like OMP approach
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
        function self = SSC_TOMP(X, K, NumSubspaces)
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

            % conduct spectral clustering
            options.num_clusters = self.NumSubspaces;
            result = spx.cluster.spectral.simple.normalized_symmetric(self.Adjacency, options);
            cluster_labels = result.labels;

            % We are disabling our version of spectral clustering for now.
            % clusterer = spx.cluster.spectral.Clustering(self.Adjacency);
            % keep reference for debugging purposes.
            % self.Clusterer = clusterer;
            % clusterer.NumClusters = self.NumSubspaces;
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
            self.NormalizedData = spx.commons.norm.normalize_l2(data);
            % Number of data vectors
            ns = self.S;
            % iterate over signals
            all_cols = 1:ns;
            for s=all_cols
                if ~self.Quiet 
                    if mod(s, 50) == 0
                        fprintf('.');
                    end
                    if mod(s, 1000) == 0
                        fprintf('\n');
                    end
                end
                self.tree_omp(s);
            end
            if ~self.Quiet 
                fprintf('\n');
            end
        end

        function tree_omp(self, s)
            % Apply nearest neighbor OMP on s-th vector.
            % data matrix
            X = self.NormalizedData;
            % Current vector
            x =X(:, s);
            % number of vectors
            ns = self.S;
            % Subspace dimension
            nk = self.K;
            % current candidate residuals
            candidate_residuals = x;
            % norm of current residual
            res_norm = norm(candidate_residuals);
            % ambient dimension
            nd = self.N;
            % selected indices for supports
            candidate_supports = [];
            % max number of iterations
            max_iter = nk;
            % maximum residual norm
            max_res_norm = 1e-3;
            % maximum number of nearest neighbors
            nn = min (max(2*(nk-1), 2), round(ns/2) );

            % Let us carry out the first iteration separately.
            % We compute the inner products with x
            inner_products = X' * x;
            % ignore s-th column
            inner_products(s) = 0;
            % take absolute values
            inner_products = abs(inner_products);
            % Find the highest inner products
            [sorted_inner_products, indices] = sort(inner_products, 'descend');
            % choose two candidate supports
            candidate_supports = indices(1:2)';
            candidate_ids = [0 1];
            % number of candidate supports
            nc  = size(candidate_supports, 2);
            candidate_residuals = zeros(nd, nc);
            residual_norms = zeros(1, nc);
            for c=1:nc
                % pick up a candidate support [c-th column]
                candidate_support = candidate_supports(:, c);
                % Solve least squares problem
                subdict = X(:, candidate_support);
                % coefficients
                tmp = linsolve(subdict, x);
                % Let us update the residual.
                candidate_residual = x - subdict * tmp;
                candidate_residuals(:, c) = candidate_residual;
                residual_norms(c) = norm(candidate_residual);
            end
            % fprintf('Residual norms: ');
            % fprintf('%0.2f ', residual_norms);
            % fprintf('\n');
            % Now we iterate for higher sparsity levels
            for iter=2:max_iter
                % We work through current candidate supports and residuals
                nc  = size(candidate_residuals, 2);
                nnc = 2*nc;
                new_candidate_supports = zeros(iter, nnc);
                new_candidate_ids = zeros(1, nnc);
                for c=1:nc
                    candidate_support = candidate_supports(:, c);
                    candidate_residual = candidate_residuals(:, c);
                    residual_norm = residual_norms(c);
                    % normalize the residual 
                    candidate_residual = candidate_residual / residual_norm;
                    % compute inner products
                    inner_products = X' * candidate_residual;
                    % ignore s-th column
                    inner_products(s) = 0;
                    % ignore already used indices
                    inner_products(candidate_support) = 0;
                    % take absolute values
                    inner_products = abs(inner_products);
                    % Find the highest inner products
                    [sorted_inner_products, indices] = sort(inner_products, 'descend');
                    i1 = indices(1);
                    i2 = indices(2);
                    s1 = [candidate_support; i1];
                    s2 = [candidate_support; i2];
                    % add these new candidate supports
                    new_candidate_supports(:, 2*c - 1) = s1;
                    new_candidate_supports(:, 2*c) = s2;
                    candidate_id = candidate_ids(c);
                    % assign binary code to the tree branch taken here.
                    new_candidate_ids(2*c -1 ) = candidate_id*2;
                    new_candidate_ids(2*c) = candidate_id*2 + 1;
                end
                % create space for new residuals
                candidate_residuals = zeros(nd, nnc);
                residual_norms = zeros(1, nnc);
                for c=1:nnc
                    % compute new residual for each candidate
                    candidate_support = new_candidate_supports(:, c);
                    % Solve least squares problem
                    subdict = X(:, candidate_support);
                    % coefficients
                    tmp = linsolve(subdict, x);
                    % Let us update the residual.
                    candidate_residual = x - subdict * tmp;
                    candidate_residuals(:, c) = candidate_residual;
                    residual_norms(c) = norm(candidate_residual);
                end
                % replace candidate supports by new candidate supports
                candidate_supports = new_candidate_supports;
                candidate_ids = new_candidate_ids;
                % fprintf('Residual norms: ');
                % fprintf('%0.2f ', residual_norms);
                % fprintf('\n');
                [sorted_norms, norm_indices] = sort(residual_norms);
                min_norm = sorted_norms(1);
                % we will keep candidate supports for up to twice of the minimum norm
                max_norm_threshold = min_norm * 2;
                % identify the candidates which will be retained
                retained_indices = residual_norms < max_norm_threshold;
                % throw away data for candidates which are not retained.
                candidate_supports = candidate_supports(:, retained_indices);
                candidate_residuals= candidate_residuals(:, retained_indices);
                residual_norms =  residual_norms(:, retained_indices);
                candidate_ids = new_candidate_ids(retained_indices);
                % see if we have already arrived at our minimum norm requirement.
                if min_norm < max_res_norm
                    % We have found the needed solution
                    break;
                end
            end
            [min_norm, index] = min(residual_norms);
            %fprintf('Minimum residual norm: %0.2f, candidate id: %s\n', min_norm, dec2bin(candidate_ids(index), iter));
            % final selection
            candidate_support  = candidate_supports(:, index);
            subdict = X(:, candidate_support);
            % coefficients
            tmp = linsolve(subdict, x);
            z = zeros(ns, 1);
            z(candidate_support) = tmp;
            self.Representation(:, s) = z;
            self.Affinity(:, s) = z;
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

