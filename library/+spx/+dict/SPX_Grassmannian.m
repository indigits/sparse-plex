classdef SPX_Grassmannian < handle
    % Ways to generate Grassmannian frames.
    properties
    end

    methods(Static)

        function result = minimum_coherence(m, n)
            % Returns the minimum coherence of an m times n matrix
            num = n - m;
            den = m * (n - 1);
            result = sqrt(num / den);
        end

        function n = n_upper_bound(m)
            % for a given value of m, returns the upper bound on n.
            a = m * (m  + 1) / 2;
            n = m  * (m + 1) / 2 - 1;
            lower_limit = m;
            while true
                b = (n - m) * (n - m + 1) / 2;
                upper_limit = min (a, b);
                if n < upper_limit
                    break;
                end
                n = n- 1;
            end
        end
        function [ns, coherences] = min_coherence_max_n(ms)
            if ~isvector(ms)
                error('ms must be a vector');
            end
            mm = length(ms);
            ns = zeros(1, mm);
            coherences = zeros(1, mm);
            for i=1:mm
                m = ms(i);
                n = SPX_Grassmannian.n_upper_bound(m);
                ns(i) = n;
                coherences(i) = SPX_Grassmannian.minimum_coherence(m, n);
            end
        end

        function n = max_n_for_coherence(m, mu)
            % estimates a value of n for m x n matrix which achieves a 
            % given coherence
            num = (mu^2 -1) * m;
            den = mu^2 * m - 1;
            n = floor(num / den);
            if n < 0
                error('A Grassmannian frame for this dimension will never have so high coherence.');
            end
        end

        function result = alternate_projections(dict, options)
            % Converts a given dictionary to Grassmannian frame via
            % alternate projections
            [n, d] = size(dict);
            % We assume that the dictionary contains unit norm atoms
            target_mu  = SPX_Grassmannian.minimum_coherence(n, d);
            % Compute the Gram matrix
            gram_matrix = dict' * dict;
            iterations = 1000;
            entry_shrinkage_factor = 0.9;
            coherence_shrinkage_factor = 0.9;
            verbose = false;
            if nargin > 1 && isstruct(options)
                if isfield(options, 'iterations')
                    iterations = options.iterations;
                end
                if isfield(options, 'entry_shrinkage_factor')
                    entry_shrinkage_factor = options.entry_shrinkage_factor;
                end
                if isfield(options, 'coherence_shrinkage_factor')
                    coherence_shrinkage_factor = options.coherence_shrinkage_factor;
                end
                if isfield(options, 'verbose')
                    verbose = options.verbose;
                end
            end
            total_entries = d^2 - d; % excluding the main diagonal.
            % Identify the indices in the gram matrix which are off diagonal
            off_diagonal_indices = abs(gram_matrix(:) - 1)> 1e-6;
            coherence_array = zeros(iterations, 1);
            mean_coherence_array = zeros(iterations, 1);
            for k=1:iterations
                % Convert gram matrix to an array
                gram_array = gram_matrix(:);
                % Absolute Gram matrix
                abs_gram_array = abs(gram_array);
                % sort the inner products by their absolute values
                sorted_gram_array = sort(abs_gram_array);
                upper_threhold_index = round(entry_shrinkage_factor * total_entries);
                upper_threshold = sorted_gram_array(upper_threhold_index);
                % identify coherence values above the threshold
                above_indices = off_diagonal_indices & (abs_gram_array > upper_threshold);
                % map the boolean flags to positions.
                above_indices = find(above_indices);
                above_values = abs_gram_array(above_indices);
                current_mu = max(above_values);
                mean_mu = mean(above_values);
                coherence_array(k) = current_mu;
                mean_coherence_array(k) = mean_mu;
                if verbose
                    fprintf('%6d:, Coherence:: target: %12.8f, ', k, target_mu);
                    fprintf('current: %12.8f, threshold: %12.8f, above: %d, mean: %12.8f\n', ...
                        current_mu, upper_threshold, length(above_values), mean_mu);
                else
                    fprintf('.');
                    if mod(k, 100) == 0
                        fprintf('\n');
                    end
                end
                % Update off diagonal entries
                gram_matrix(above_indices)=gram_matrix(above_indices)*coherence_shrinkage_factor;
                
                % reduce the rank back to n
                [U,S,V]=svd(gram_matrix);
                % Ensure that all higher singular values are set to 0. 
                S(n+1:end,n+1:end)=0;
                % Reconstruct the Gram matrix.
                gram_matrix=U*S*V';
                % Ensure that the diagonal elements of G continue to be 1.
                % Compute  d = diag(G)  d^{-1/2}.
                gram_diag_sqrt_inv = diag(1./sqrt(diag(gram_matrix)));
                % Compute G = d^{-1/2} G d^{-1/2}.
                gram_matrix = gram_diag_sqrt_inv*gram_matrix*gram_diag_sqrt_inv;
            end
            % final dictionary
            % perform SVD of the gram matrix.
            [U,S,V]=svd(gram_matrix);
            % Construct the dictionary 
            dict=S(1:n,1:n).^0.5*U(:,1:n)';
            result.dictionary = dict;
            result.coherence_array = coherence_array;
            result.mean_coherence_array = mean_coherence_array;
            result.target_coherence = target_mu;
            result.iterations = iterations;
        end
    end
end
