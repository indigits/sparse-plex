classdef SSC_MC_OMP < handle
    % Implements sparse subspace clustering algorithm using OMP algorithm
    properties
        Quiet = false
        % The branching factor
        BranchingFactor = 2
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

        function recover_coefficients(self)
            % Computes sparse representations of the data vectors
            data_matrix = self.Data;
            data_matrix = spx.commons.norm.normalize_l2(data_matrix);
            % Number of data vectors
            ns = self.S;
            % sparsity level
            nk = self.K;
            % ambient dimension
            nd = self.N;

            % number of iterations vector
            % contains the number of iterations in each a particular vector was solved.
            % initially it is set to K
            % the moment residual norm reduces below the threshold
            % we mark it as finished and store the number of iterations
            % in this vector
            num_iterations_vec = nk * ones(ns, 1);
            % maintains if processing for a particular data point has been completed.
            termination_vector = false(1, ns);

            % 2 dimensional arrays
            % dim 1 : iteration or residual
            % dim 2 : candidate index
            % for candidate_support dim 1 is iteration number
            % for residual dim 1 is M, ambient dimension
            % for candidate id, dim 1 is branching direction
            % retaining candidates are filtered over dim 2.

            % number of candidates for each data point
            bf = self.BranchingFactor;
            num_candidate_list = ones(1, ns);
            num_total_candidates = sum(num_candidate_list);
            candidate_supports = [];
            candidate_ids = [];
            candidate_residuals = data_matrix;
            residual_norms = [];
            % the sorted index matrix for the inner products of data with candidate residuals
            sorted_index_matrix = [];

            % threshold for squared norm of residual 
            threshold = self.ResidualNormThreshold;



            function [r, r_norm] = compute_residual(x, support_set)
                % pick atoms
                submatrix = data_matrix(:, support_set);
                % solve the least squares problem
                r = x - submatrix * (submatrix \ x);
                % residual norm
                r_norm = norm(r);
            end

            function compute_residuals()
                % new_candidate_supports
                % new_candidate_ids
                % create space for new residuals
                if iter == nk
                    % nothing to do
                    return;
                end
                candidate_residuals = zeros(nd, num_total_candidates);
                residual_norms = zeros(1, num_total_candidates);
                % current candidate start and end positions
                [cand_starts cand_ends] = spx.cluster.start_end_indices(num_candidate_list);
                for s=1:ns
                    % this vector requires more iterations.
                    % pick the vector
                    x = data_matrix(:, s);
                    cand_start = cand_starts(s);
                    cand_end = cand_ends(s);
                    if termination_vector(s) 
                        % the processing for this vector is already computed
                        % we don't need to retain  its residual
                        continue;
                    end
                    for c=cand_start:cand_end
                        % fprintf('Processing candidate: %d\n', c);
                        % compute new residual for each candidate
                        [candidate_residuals(:, c) , residual_norms(c)] = compute_residual(x, candidate_supports(:, c));
                    end
                end
            end





            function filter_candidates()
                % iterate for each data point
                retained_indices = [];
                % This function modifies following:
                % num_candidate_list
                % candidate_supports
                % candidate_ids
                % candidate_residuals
                % residual_norms
                [cand_starts cand_ends] = spx.cluster.start_end_indices(num_candidate_list);
                for s=1:ns
                    cand_start = cand_starts(s);
                    cand_end = cand_ends(s);
                    if termination_vector(s) 
                        % this vector has only one candidate left keep it and continue
                        assert (cand_start == cand_end);
                        retained_indices = [retained_indices cand_start];
                        num_candidate_list(s) = 1;
                        continue;
                    end
                    % we need to filter out extra candidates
                    try
                        r_norms = residual_norms(cand_start:cand_end);
                    catch ME
                        fprintf('Problem for s=%d, start: %d, end: %d\n', s, cand_start, cand_end);
                        print_processing_status();
                        rethrow(ME);
                    end
                    [sorted_norms, norm_indices] = sort(r_norms);
                    min_norm = sorted_norms(1);
                    if min_norm <= threshold
                        % this vector processing is complete
                        retained = norm_indices(1);
                        % processing for this vector is completed
                        termination_vector(s) = true;
                        num_iterations_vec(s) = iter;
                    else
                        % we will keep candidate supports for up to twice of the minimum norm
                        max_norm_threshold = min_norm * 2;
                        % identify the candidates which will be retained
                        retained = find(r_norms < max_norm_threshold);
                    end
                    % We will keep only top ten indices
                    if (numel(retained) > 10)
                        retained = norm_indices(1:10);
                    end
                    % absolute position of retained columns
                    retained = retained + cand_start - 1;
                    num_candidate_list(s) = numel(retained);
                    %  the candidates to be retained
                    retained_indices = [retained_indices retained];
                end
                % we clean up all candidates
                % throw away data for candidates which are not retained.
                candidate_supports = candidate_supports(:, retained_indices);
                candidate_ids =  candidate_ids(retained_indices);
                candidate_residuals= candidate_residuals(:, retained_indices);
                residual_norms =  residual_norms(:, retained_indices);
                num_total_candidates = sum(num_candidate_list);
            end


            function compute_correlation_matrix()
                % let us carry out the first iteration separately for all vectors
                % data_matrix is M \times S
                % candidate_residuals is M \times C
                % correlation matrix is S \times C
                % correlation_matrix = abs(data_matrix' * candidate_residuals);
                % return;
                counter = 0;
                [M, S] = size(data_matrix);
                [M , C] = size(candidate_residuals);
                c_blk_size = 2^nextpow2(round(10*1000*1000 / (M * S)));
                sorted_index_matrix = zeros(bf, C);

                % current candidate start and end positions
                num_points_list = [];
                num_bunch_candidates_list = [];
                counter = 0;
                s_count = 0;
                for s=1:ns
                    counter = counter + num_candidate_list(s);
                    s_count = s_count + 1;
                    if counter >= c_blk_size
                        num_points_list = [num_points_list s_count];
                        num_bunch_candidates_list = [num_bunch_candidates_list counter];
                        counter = 0;
                        s_count = 0;
                    end
                end
                if counter > 0
                    % last bunch
                    num_points_list = [num_points_list s_count];
                    num_bunch_candidates_list = [num_bunch_candidates_list counter];
                end
                assert (sum(num_points_list) == ns);
                assert (sum(num_bunch_candidates_list) == num_total_candidates);

                [s_starts, s_ends] = spx.cluster.start_end_indices(num_points_list);
                [c_starts, c_ends] = spx.cluster.start_end_indices(num_bunch_candidates_list);
                for ss=1:numel(num_points_list)
                    s_start = s_starts(ss);
                    s_end = s_ends(ss);
                    c_start = c_starts(ss);
                    c_end  = c_ends(ss);
                    c_mask = [c_start:c_end];
                    % compute correlation for current bunch of candidates
                    corr_mat = abs(data_matrix' * candidate_residuals(:, c_mask));
                    % set all the diagonal entries (inner product with self) to zero.
                    c = 0;
                    for s=s_start:s_end
                        nc = num_candidate_list(s);
                        for ccc=1:nc
                            c = c+1;
                            corr_mat(s, c) = 0;
                        end
                    end
                    % sort each column
                    [sorted_corr_mat , ind_mat] = sort(corr_mat, 'descend');
                    sorted_index_matrix(:, c_start:c_end) = ind_mat(1:bf, :);
                end
            end

            function initialize_candidates()
                compute_correlation_matrix();
                num_candidate_list = bf * ones(1, ns);
                num_total_candidates = sum(num_candidate_list);
                [cand_starts cand_ends] = spx.cluster.start_end_indices(num_candidate_list);
                % disp(sorted_corr_mat(1, :));
                % we choose candidate supports as first bf rows of index matrix
                candidate_supports = reshape(sorted_index_matrix, 1, num_total_candidates);
                candidate_ids = repmat((0:1:bf-1), 1, ns);
                % We compute all the residuals
                compute_residuals();
            end

            function update_candidates()
                assert(size(candidate_supports, 2) == num_total_candidates);
                % starting with current candidate list, 
                % we create new candidate list.
                % We correlated data with residual.
                % to do change this to handle cases where there are too many points to handle
                % In the sequel
                % s is data point index
                % c is old candidate index
                % new_c is new candidate index
                compute_correlation_matrix(); 
                % current candidate start and end positions
                [cand_starts cand_ends] = spx.cluster.start_end_indices(num_candidate_list);
                % new number of candidates for each data point 
                new_num_candidate_list = zeros(1, ns);
                % for vectors whose processing is complete, we won't create new candidates
                new_num_candidate_list(termination_vector) = num_candidate_list(termination_vector);
                % for vectors whose processing is still on, for each existing candidate, we create bf new candidates
                new_num_candidate_list(~termination_vector) = bf * num_candidate_list(~termination_vector);
                num_new_total_candidates = sum(new_num_candidate_list);
                % start and end indices for new candidates for each vector
                [new_cand_starts new_cand_ends] = spx.cluster.start_end_indices(new_num_candidate_list);
                % allocate space for new candidate supports
                new_candidate_supports = zeros(iter, num_new_total_candidates);
                new_candidate_ids = zeros(1, num_new_total_candidates);
                % fill in new candidate supports
                for s=1:ns
                    cand_start = cand_starts(s);
                    cand_end = cand_ends(s);
                    new_c = new_cand_starts(s);
                    if termination_vector(s)
                        % processing for this vector is completed
                        assert (cand_start == cand_end);
                        assert (num_candidate_list(s) == 1);
                        % retain the only candidate
                        new_candidate_supports(:, new_c) = [candidate_supports(:, cand_start); 0];
                        new_candidate_ids(new_c) = candidate_ids(cand_start);
                        continue;
                    end
                    for c=cand_start:cand_end
                        indices = sorted_index_matrix(:, c);
                        candidate_support = candidate_supports(:, c);
                        candidate_id = candidate_ids(c);
                        % we create new candidates based on branching factor
                        for b=1:bf
                            new_candidate_support = [candidate_support; indices(b)];
                            new_candidate_supports(:, new_c) = new_candidate_support;
                            new_candidate_ids(new_c) = candidate_id*bf + b-1;
                            % move on to next new candidate
                            new_c = new_c + 1;
                        end
                    end
                end
                % update candidate lists and supports
                candidate_supports = new_candidate_supports;
                candidate_ids = new_candidate_ids;
                num_candidate_list = new_num_candidate_list;
                num_total_candidates = num_new_total_candidates;
            end

            function print_residuals()
                fprintf('Residual norms: ');
                fprintf('%0.2f ', residual_norms);
                fprintf('\n');
            end

            function print_candidate_count_list()
                fprintf('Number of candidates: ');
                fprintf('%d ', num_candidate_list);
                fprintf('\n');
            end

            function print_processing_status(message)
                if nargin >= 1
                    fprintf('%s ', message);
                end
                fprintf('Iteration: %d, terminated: %d ', iter, sum(termination_vector));
                fprintf('candidates: %d, %d, %d, %d, %d\n ', ...
                 num_total_candidates, sum(num_candidate_list), size(candidate_supports, 2), ...
                 size(candidate_residuals, 2), numel(residual_norms));
                return;
                for s=1:ns
                    fprintf('%d: %d %s, ', s, num_candidate_list(s), spx.io.yes_no(termination_vector(s)));
                    if (mod(s, 10) == 0)
                        fprintf('\n');
                    end
                end
                fprintf('\n');
            end


            % first iteration
            iter = 1;
            % initialize first iteration candidates
            initialize_candidates();
            % filter out unlikely candidates
            filter_candidates();
            % print_processing_status;

            for iter=2:nk
                if ~self.Quiet 
                    fprintf('.');
                end
                % update candidates
                update_candidates();
                % print_processing_status('update candidates');
                compute_residuals();
                % print_processing_status('compute residual');
                if iter ~= nk
                    filter_candidates();
                    % print_processing_status('filter candidates');
                end
                % % now check if processing for all vectors have been terminated
                % continuing = num_iterations_vec == nk;
                if sum(~termination_vector) == 0
                    % all vectors have been terminated
                    break;
                end
            end


            % the values of coefficients corresponding to support sets
            coefficients_matrix = zeros(ns, nk);
            % support set for each vector [one row for each vector]
            support_sets = ones(ns, nk);
            function compute_final_coefficients
                % final computation of coefficients
                % Creation of sparse representation matrix
                % current candidate start and end positions
                [cand_starts cand_ends] = spx.cluster.start_end_indices(num_candidate_list);
                for s=1:ns
                    nc  = num_candidate_list(s);
                    cs = cand_starts(s);
                    ce = cand_ends(s);
                    % number of iterations for this vector
                    k = num_iterations_vec(s);
                    coeff_norms = zeros(1, nc);
                    coeff_mat = zeros(k, nc);
                    x = self.Data(:, s);
                    for c=1:nc
                        candidate_support = candidate_supports(1:k, c+cs-1);
                        % pick atoms from the unnormalized data matrix
                        submatrix = self.Data(:, candidate_support);
                        % solve the least squares problem
                        coeff = submatrix \ x;
                        coeff_mat(:, c) = coeff;
                        coeff_norms(c) = norm(coeff);
                    end
                    % choose the best candidate
                    [best_norm, best_index] = max(coeff_norms);
                    coeff = coeff_mat(:, best_index);
                    support_set = candidate_supports(1:k, best_index+cs -1);
                    support_sets(s, 1:k) = support_set;
                    % put the coefficients back into coefficients matrix
                    coefficients_matrix(s, 1:k) = coeff';
                end
            end

            % let us compute final coefficients
            compute_final_coefficients();

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
            self.Iterations = num_iterations_vec;
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
            % C = spx.commons.norm.normalize_linf(C);
            % Make it symmetric
            C = C + C';
            % Keep it
            self.Adjacency = C;
        end

    end

end

