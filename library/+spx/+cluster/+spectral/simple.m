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
    end

    function result = normalized_symmetric(W)
        % Maximum iteration for KMeans Algorithm
        max_iterations = 1000; 
        % Replication for KMeans Algorithm
        replicates = 100;
        % maximum number of clusters supported by the algorithm
        max_clusters = 200;
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
        [ min_val , ind_min ] = min( diff( singular_values(1:end-1) ) ) ;
        % Number of 0 singular values
        % Number of clusters
        num_clusters = size(W, 1) - ind_min;
        % Choose the last num_clusters eigen vectors
        Kernel = V(:,num_nodes-num_clusters+1:num_nodes);
        % We need to normalize the rows of kernel
        Kernel = spx.commons.norm.normalize_l2_rw(Kernel);
        % Result of clustering the rows of eigen vectors
        fprintf('Number of clusters: %d\n', num_clusters);
        if num_clusters >  max_clusters 
            % we don't want kmeans to run indefinitely.
            max_iterations = 2;
            replicates = 2;
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
    end

end

end