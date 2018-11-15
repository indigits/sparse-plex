classdef simple
% These ones are based on codes from Mahdi, Elhamifar. 
% They are simpler than the code in
% spx.cluster.spectral.Clustering.

methods(Static)

    function result = unnormalized(W)
        % Maximum iteration for KMeans Algorithm
        max_iterations = 1000; 
        % Replication for KMeans Algorithm
        replicates = 100;
        % number of nodes
        [m, n] = size(W);
        assert (m == n);
        num_nodes = m; 
        % degree matrix
        Degree = diag(sum(W));
        Laplacian = Degree - W;
        [~, S, V] = svd(Laplacian);
        singular_values = diag(S);
        [ min_val , ind_min ] = min( diff( singular_values(1:end-1) ) ) ;
        % Number of 0 singular values
        % Number of clusters
        num_clusters = size(W, 1) - ind_min;
        % Choose the last num_clusters eigen vectors
        Kernel = V(:,num_nodes-num_clusters+1:num_nodes);
        % Result of clustering the rows of eigen vectors
        labels = kmeans(Kernel, num_clusters, ...
            'start','sample', ...
            'maxiter',max_iterations,...
            'replicates',replicates, ...
            'EmptyAction','singleton'...
            );
        result.labels = labels;
        result.singular_values = singular_values;
        result.Laplacian = Laplacian;
        result.num_clusters = num_clusters;
        % second last element is the connectivity value
        result.connectivity = singular_values(end-1);
    end


    function result = normalized_random_walk(W)
        % Maximum iteration for KMeans Algorithm
        max_iterations = 1000; 
        % Replication for KMeans Algorithm
        replicates = 100;
        % number of nodes
        [m, n] = size(W);
        assert (m == n);
        num_nodes = m; 
        % degree matrix
        Degree = diag(sum(W));
        DegreeInv = Degree^(-1);
        Laplacian = speye(num_nodes) - DegreeInv * W;
        [~, S, V] = svd(Laplacian);
        singular_values = diag(S);
        [ min_val , ind_min ] = min( diff( singular_values(1:end-1) ) ) ;
        % Number of 0 singular values
        % Number of clusters
        num_clusters = size(W, 1) - ind_min;
        % Choose the last num_clusters eigen vectors
        Kernel = V(:,num_nodes-num_clusters+1:num_nodes);
        % Result of clustering the rows of eigen vectors
        labels = kmeans(Kernel, num_clusters, ...
            'start','sample', ...
            'maxiter',max_iterations,...
            'replicates',replicates, ...
            'EmptyAction','singleton'...
            );
        result.labels = labels;
        result.singular_values = singular_values;
        result.Laplacian = Laplacian;
        result.num_clusters = num_clusters;
        % second last element is the connectivity value
        result.connectivity = singular_values(end-1);
    end

    function result = normalized_symmetric(W, options)
        % Maximum iteration for KMeans Algorithm
        max_iterations = 1000; 
        % Replication for KMeans Algorithm
        replicates = 100;
        % maximum number of clusters supported by the algorithm
        max_clusters = 200;
        num_clusters = -1;
        if nargin > 1 
            if isfield(options, 'num_clusters')
                num_clusters = options.num_clusters;
            end
            if isfield(options, 'max_clusters')
                max_clusters = options.max_clusters;
            end
        end
        % number of nodes
        [m, n] = size(W);
        assert (m == n);
        num_nodes = m; 
        % degree matrix
        Degree = diag(sum(W));
        DegreeHalfInv = Degree^(-1/2);
        Laplacian = speye(num_nodes) - DegreeHalfInv * W * DegreeHalfInv;
        [~, S, V] = svd(Laplacian);
        singular_values = diag(S);
        if num_clusters < 0
            % strategy to compute the number of clusters
            [ min_val , ind_min ] = min( diff( singular_values(1:end-1) ) ) ;
            % Number of 0 singular values
            % Number of clusters
            num_clusters = size(W, 1) - ind_min;
        end
        % Choose the last num_clusters eigen vectors
        Kernel = V(:,num_nodes-num_clusters+1:num_nodes);
        % We need to normalize the rows of kernel
        Kernel = spx.norm.normalize_l2_rw(Kernel);
        % Result of clustering the rows of eigen vectors
        %fprintf('Number of clusters: %d\n', num_clusters);
        if num_clusters >  max_clusters 
            % We will restrict the number of clusters
            num_clusters = max_clusters;
            % we don't want kmeans to run indefinitely.
            % max_iterations = 2;
            % replicates = 2;
        end
        labels = kmeans(Kernel, num_clusters, ...
            'start','sample', ...
            'maxiter',max_iterations,...
            'replicates',replicates, ...
            'EmptyAction','singleton'...
            );
        result.labels = labels;
        result.singular_values = singular_values;
        result.Laplacian = Laplacian;
        result.num_clusters = num_clusters;
        % second last element is the connectivity value
        result.connectivity = singular_values(end-1);
    end

    % NCut spectral clustering algorithm adopted from Chong You SSC-OMP work.
    % The computation is equivalent to:
    % - compute the largest eigenvectors of D^{-1} W
    % - normalize the rows of the resultant matrix
    % - then apply kmeans to the rows.
    function result = normalized_symmetric_sparse(W, num_clusters)
        if ~issymmetric(W)
            error('Adjacency matrix must be symmetric.');
        end
        % Maximum iteration for KMeans Algorithm
        max_iterations = 1000; 
        % Replication for KMeans Algorithm
        replicates = 20;
        % number of nodes
        [m, ~] = size(W);
        num_nodes = m; 
        % degree matrix
        % degree_vec = full(sum(W));
        % W2 = bsxfun(@rdivide, W, degree_vec + eps);
        % following is a shortcut to compute D^{-1} W
        W2 = spx.norm.normalize_l1_rw(W);
        [Kernel, ~] = eigs(W2, num_clusters, 'LR');
        % We need to normalize the rows of kernel
        Kernel = spx.norm.normalize_l2_rw(Kernel);
        labels = kmeans(Kernel, num_clusters, ...
            'start','plus', ...
            'maxiter',max_iterations,...
            'replicates',replicates, ...
            'EmptyAction','singleton'...
            );
        result.labels = labels;
        result.num_clusters = num_clusters;
        % second last element is the connectivity value
        result.connectivity = -1;
    end


    function conn = connectivity(C, labels)
        % C \in R^N-by-N: symmetric affinity matrix
        % s \in {1, 2, ... n}^N: group labels
        % 
        % conn: connectivity index
        % conn = min_{i = 1,...,n} (second-least eigenvalue of L_i);
        if ~issymmetric(C)
            warning('(evalConn) affinity matrix not symmetric')
        end
        unique_labels = unique(labels);
        num_labels = length(unique_labels);
        % start with infinite connectivity
        conn = inf;
        for in = 1:num_labels
            % identify rows and columns of data for a particular group
            indices = (labels == unique_labels(in));
            % the submatrix for data belonging to points from a given cluster
            C_in = C(indices, indices);
            % conn
            if min(sum(C_in, 2)) < eps
                conn_in = 0.0;
            else
                OPTS.tol = 1e-3;
                % normalize the columns of C_in
                C_in = spx.norm.normalize_l1(C_in);
                % compute the eigen values
                [~, eig_in] = eigs( C_in', 2, 'LR', OPTS );
                % pick the second eigen value and compute connectivity
                conn_in = 1 - eig_in(2, 2);
            end
            % overall connectivity is the minimum of all
            conn = min( [conn, conn_in] );
        end
    end


end

end