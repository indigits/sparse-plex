classdef MC_OMP < handle
    %MC_OMP Implements the Multiple Candidates OMP algorithm for sparse approximation

    properties
        % These properties can be configured before running cosamp
        % Default residual norm threshold
        ResidualNormThreshold = 1e-6;
        % Indicates if we should stop on exceeding residual norm
        StopOnResidualNorm = true
        % Indicates if we should stop when residual norm stops improving
        StopOnResNormStable = true
        % Maximum number of iterations for approximation
        MaxIters
        % Indicates if extra logging should be done.
        Verbose = false
        % The branching factor
        BranchingFactor = 2
        % Number of candidates to retain in each iteration
        MaxCandidatesToRetain = 4
    end

    properties(SetAccess=private)
        % The dictionary
        Dict
        % Ambient signal dimensions
        N
        % Number of atoms in dictionary
        D
        % Sparsity level of representations (may be negative)
        K
        % Result of a solver
        result
    end
    
    methods
        function self  = MC_OMP(Dict, K)
            % We assume that all the columns in dictionary are normalized.
            if isa(Dict, 'spx.dict.Operator')
                self.Dict = Dict;
            elseif ismatrix(Dict)
                self.Dict = spx.dict.MatrixOperator(Dict); 
            else
                error('Unsupported operator.');
            end
            [self.N, self.D] = size(Dict);
            if ~exist('K', 'var')
                % No sparsity level has been pre-specified.
                % We make an estimate of sparsity level
                % based on phase transition analysis by Donoho
                K = round((self.N / 2) * log (self.D));
            end
            self.K = K;
            % Maximum number of iterations
            maxIter = self.N;
            if K > 0
                % We have to consider pre-specified sparsity level
                maxIter = K;
            end
            self.MaxIters = maxIter;
        end

        function result  = solve(self,y)
            % Solves approximation problem using OMP

            % Initialization

            % number of atoms
            d = self.D;
            % signal dimension
            n = self.N;
            % dictionary
            dict = self.Dict;
            % sparsity level
            nk = self.K;
            % number of candidates for each data point in each iteration
            bfs = self.BranchingFactor;
            if isscalar (bfs)
                bfs = bfs * ones(1, nk);
            end
            if length(bfs) ~= nk
                error('Branching factor for all iterations must be specified.');
            end
            % current branching factor
            bf = 0;
            mcrt = self.MaxCandidatesToRetain;
            % number of candidates in current iteration
            num_total_candidates = 1;
            % corresponding supports
            candidate_supports = [];
            % corresponding ids
            candidate_ids = [];
            % corresponding residuals (for each candidate)
            candidate_residuals = y;
            % space for storing residual norms
            residual_norms = [];

            % the sorted index matrix for the inner products of dictionary with candidate residuals
            sorted_index_matrix = [];
            % the sorted inner products of dictionary with candidate residuals
            sorted_inner_products = [];

            % threshold for squared norm of residual 
            threshold = self.ResidualNormThreshold;

            % flag for indicating that the algorithm should be terminated
            terminate = false;
            % counter for number of iterations taken for algorithm to converge
            num_iterations = nk;


            % Local functions for implementation of this algorithm
            function [r, r_norm] = compute_residual(x, support_set)
                % pick atoms
                submatrix = dict.columns(support_set);
                % solve the least squares problem
                r = x - submatrix * (submatrix \ x);
                % residual norm
                r_norm = norm(r);
            end

            function compute_residuals()
                if iter == nk
                    % nothing to do
                    return;
                end
                % create space for new residuals
                candidate_residuals = zeros(n, num_total_candidates);
                residual_norms = zeros(1, num_total_candidates);
                % this vector requires more iterations.
                for c=1:num_total_candidates
                    if self.Verbose
                        % fprintf('Processing candidate: %d\n', c);
                        % compute new residual for each candidate
                    end
                    [candidate_residuals(:, c) , residual_norms(c)] = compute_residual(y, candidate_supports(:, c));
                end
            end

            function compute_correlation_matrix()
                % let us carry out the first iteration separately for all vectors
                % data_matrix is M \times S
                % candidate_residuals is M \times C
                % correlation matrix is S \times C
                correlation_matrix = abs(dict' * candidate_residuals);
                [sorted_inner_products, sorted_index_matrix] = sort(correlation_matrix, 'descend');
                return;
            end


            function initialize_candidates()
                compute_correlation_matrix();
                num_total_candidates = bf;
                % disp(sorted_corr_mat(1, :));
                % we choose candidate supports as first bf rows of index matrix
                candidate_supports = reshape(sorted_index_matrix(1:bf, :), 1, num_total_candidates);
                candidate_ids = (0:1:bf-1);
                % We compute all the residuals
                compute_residuals();
            end


            function filter_candidates()
                % iterate for each data point
                retained_indices = [];
                % This function modifies following:
                % num_total_candidates
                % candidate_supports
                % candidate_ids
                % candidate_residuals
                % residual_norms
                % we need to filter out extra candidates
                [sorted_norms, norm_indices] = sort(residual_norms);
                min_norm = sorted_norms(1);
                if min_norm <= threshold
                    % this vector processing is complete
                    retained = norm_indices(1);
                    % processing for this vector is completed
                    terminate = true;
                    num_iterations = iter;
                else
                    % we will keep candidate supports for up to twice of the minimum norm
                    max_norm_threshold = min_norm * 2;
                    % identify the candidates which will be retained
                    retained = find(residual_norms < max_norm_threshold);
                end
                % We will keep only top few indices
                if (numel(retained) > mcrt)
                    retained = norm_indices(1:mcrt);
                end
                if self.Verbose
                    fprintf('Old candidates count: %d, retained candidates count: %d\n', num_total_candidates, numel(retained));
                end
                num_total_candidates = numel(retained);
                %  the candidates to be retained
                retained_idex_flags = false(1, num_total_candidates);
                retained_idex_flags(retained) = true;
                % we clean up all candidates
                % throw away data for candidates which are not retained.
                candidate_supports = candidate_supports(:, retained_idex_flags);
                candidate_ids =  candidate_ids(retained_idex_flags);
                candidate_residuals= candidate_residuals(:, retained_idex_flags);
                residual_norms =  residual_norms(:, retained_idex_flags);
            end

            function update_candidates()
                assert(size(candidate_supports, 2) == num_total_candidates);
                % starting with current candidate list, 
                % we create new candidate list.
                % We correlated dictionary atoms with residuals.
                % to do change this to handle cases where there are too many points to handle
                % In the sequel
                % c is old candidate index
                % new_c is new candidate index
                compute_correlation_matrix(); 
                % we create bf new candidates
                num_new_total_candidates = bf * num_total_candidates;
                % allocate space for new candidate supports
                new_candidate_supports = zeros(iter, num_new_total_candidates);
                new_candidate_ids = zeros(1, num_new_total_candidates);
                % fill in new candidate supports
                new_c = 1;
                for c=1:num_total_candidates
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
                % update candidate lists and supports
                candidate_supports = new_candidate_supports;
                candidate_ids = new_candidate_ids;
                num_total_candidates = num_new_total_candidates;
            end



            function print_residuals()
                fprintf('Residual norms: ');
                fprintf('%0.2f ', residual_norms);
                fprintf('\n');
            end

            % first iteration
            iter = 1;
            bf = bfs(iter);
            if bf >= 1
                % initialize first iteration candidates
                initialize_candidates();
            else
                initialize_candidates_adaptive();
            end
            % filter out unlikely candidates
            filter_candidates();
            % print_processing_status;
            for iter=2:nk
                if self.Verbose 
                    fprintf('.');
                end
                bf = bfs(iter);
                if bf >= 1
                    % update candidates
                    update_candidates();
                else
                    % update candidates
                    update_candidates_adaptive();
                end
                % print_processing_status('update candidates');
                compute_residuals();
                % print_processing_status('compute residual');
                if iter ~= nk
                    filter_candidates();
                    % print_processing_status('filter candidates');
                end
                % % now check if processing for all vectors have been terminated
                % continuing = num_iterations_vec == nk;
                if terminate
                    % all vectors have been terminated
                    break;
                end
            end
            if self.Verbose 
                fprintf('\n');
            end
            num_coeffs = nk;
            % the values of coefficients corresponding to support sets
            coefficients = zeros(num_iterations, 1);
            % support set for final solution
            support_set = ones(1, num_iterations);
            % final residual
            residual = zeros(n, 1);
            function compute_final_coefficients
                candidate_residuals = zeros(n, num_total_candidates);
                residual_norms = zeros(1, num_total_candidates);
                % number of iterations for this vector
                k = num_iterations;
                coeff_norms = zeros(1, num_total_candidates);
                coeff_mat = zeros(k, num_total_candidates);
                local_r_norms = zeros(1, num_total_candidates);
                for c=1:num_total_candidates
                    candidate_support = candidate_supports(1:k, c);
                    % pick atoms from the unnormalized data matrix
                    submatrix = dict.columns(candidate_support);
                    % solve the least squares problem
                    coeff = submatrix \ y;
                    coeff_mat(:, c) = coeff;
                    r = y  - submatrix * coeff;
                    residual_norms(c) = norm(r);
                    coeff_norms(c) = norm(coeff);
                    candidate_residuals(:, c) = r;
                end
                % choose the best candidate
                [best_norm, best_index] = min(residual_norms);
                % [best_norm, best_index] = min(coeff_norms);
                coefficients = coeff_mat(:, best_index);
                support_set = candidate_supports(1:k, best_index);
                residual = candidate_residuals(:, best_index);
            end

            % let us compute final coefficients
            compute_final_coefficients();

            % write the final solution
            z = zeros(d,1);
            z(support_set) = coefficients;
            % Solution vector
            result.z = z;
            % Residual obtained
            result.r = residual;
            % Number of iterations
            result.iterations = num_iterations;
            % Solution support
            result.support = support_set;
            self.result = result;
        end


    end
end

