function representations = batch_flipped_chol_omp(data_matrix, nk, threshold, quiet)
    if nargin < 3
        threshold = 1e-3;
    end
    if nargin < 4
        quiet = false;
    end
    % Number of data vectors
    ns = size(data_matrix, 2);
    % Computes sparse representations of the data vectors
    data_matrix = spx.norm.normalize_l2(data_matrix);
    % support set for each vector [one row for each vector]
    support_sets = ones(ns, nk);
    % termination vector
    % contains the number of iterations in each a particular vector was solved.
    % initially it is set to K
    % the moment residual norm reduces below the threshold
    % we mark it as finished and store the number of iterations
    % in this vector
    termination_vector = nk * ones(ns, 1);
    % gram matrix
    gram_matrix = data_matrix' * data_matrix;
    % initialize the correlation matrix
    correlation_matrix = abs(gram_matrix);
    prev_delta = zeros(1, ns);
    % Initialization of residual norms
    res_norm_sqr = ones(1, ns);
    % the Cholesky factors
    L = zeros(ns, nk, nk);
    % Initialize it
    L(:, 1,1) = 1;
    for iter=1:nk
        if ~quiet 
            fprintf('.');
        end
        k2 = iter-1;
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
                    % pick support for this vector
                    support_set = support_sets(s, 1:iter);
                    lambda = support_set(end);
                    if iter > 1
                        b = gram_matrix(support_set(1:k2), lambda);
                        opts = struct();
                        opts.LT= true;
                        LL = reshape(L(s, 1:k2, 1:k2), [k2, k2]);
                        w = linsolve(LL, b, opts);
                        L(s, iter, 1:iter) = [w' sqrt(1 - w' * w)];                        
                    end
                    % now solve for the coefficients using LL' z = p(:,Gamma)
                    h0 = gram_matrix(:,s);
                    h0lamba = h0(support_set);
                    LL = reshape(L(s, 1:iter, 1:iter), [iter, iter]);
                    opts = struct();
                    opts.LT = true;
                    z1 = linsolve(LL, h0lamba, opts);
                    opts = struct();
                    opts.LT = true;
                    opts.TRANSA = true;
                    z = linsolve(LL, z1, opts);
                    % pick gram submatrix
                    submatrix = gram_matrix(:, support_set);
                    beta = submatrix * z;
                    h = h0 - beta;
                    % put the new correlations into correlation matrix
                    correlation_matrix(:, s) = abs(h);
                    delta = z' * beta(support_set);
                    res_norm_sqr(s) = res_norm_sqr(s) - delta + prev_delta(s);
                    prev_delta(s) = delta;
                    if res_norm_sqr(s) < threshold
                        % The processing of this vector is complete
                        termination_vector(s) = iter;
                    end
                end
            end
        end
    end
    % disp(termination_vector');
    % final computation of coefficients
    % the values of coefficients corresponding to support sets
    coefficients_matrix = zeros(ns, nk);
    % Creation of sparse representation matrix
    for s=1:ns
        % number of iterations for this vector
        k = termination_vector(s);
        support_set  = support_sets(s, 1:k);
        x = data_matrix(:, s);
        % pick atoms from the unnormalized data matrix
        submatrix = data_matrix(:, support_set);
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
    representations = sparse( support_sets(:), column_indices(:), coefficients_matrix(:), ns, ns);
    iterations = termination_vector;
    if ~quiet 
        fprintf('\n');
    end
end
