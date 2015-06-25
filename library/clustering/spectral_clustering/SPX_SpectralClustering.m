classdef SPX_SpectralClustering < handle
    % Uses spectral clustering method for clustering the data
    % See 2007_tutorial_spectral_clustering.pdf


    properties
        % User controlled properties

        % Maximum iteration for KMeans Algorithm
        MAXiter = 1000

        % Replication for KMeans Algorithm
        Replications = 5

        % Number of clusters to be detected
        NumClusters = -1

        % Maximum number of clusters (as a hint)
        MaxClusters = -1

        Debug = false
    end


    properties(SetAccess=private)
        % read-only properties

        % The weighted adjacency matrix to be clustered
        W
        % Number of data points
        N
        % The degree vector
        DegreeVec
        % The degree matrix
        DegreeMat
        % The unnormalized laplacian
        Laplacian
        % The result of clustering
        Labels
        % Singular values
        SingularValues
        % Eigen Vectors used for clustering
        EigenVectors
        % Time spent in K-means
        KMeansTime
        % SVD time
        SVDTime
    end




    methods
        function self = SPX_SpectralClustering(WeightedAdjacencyMatrix)
            % Constructor
            self.W = WeightedAdjacencyMatrix;
            self.N = size(WeightedAdjacencyMatrix, 1);
            % We assume that similarity matrix is symmetric
            % Compute the sum of weights as the degree vector
            self.DegreeVec = sum(self.W);
            self.DegreeMat = diag(self.DegreeVec);
            self.Labels = zeros(self.N, 1);
            self.MaxClusters  = floor(self.N / 10);
        end
        
        function result = cluster_unnormalized(self)
            % Performs clustering using unnormalized approach

            % Compute the Laplacian
            n = self.N;
            self.Laplacian = self.DegreeMat - self.W;
            % Perform singular value decomposition of the unnormalized laplacian
            [~, S, V] = svd(self.Laplacian);
            self.SingularValues = diag(S);
            self.EigenVectors = V;

            % Number of clusters
            k = self.NumClusters;
            if k < 0
                k = self.find_num_clusters(self.SingularValues); 
            end
            % Number of clusters must be less than the number of points.
            assert(k <= n);
            % Pick up the eigen vectors corresponding to the smallest singular values
            eigenVectors = V(:,n-k+1:n);
            % Run k-means clustering on chosen eigen vectors
            self.cluster_eigen_vectors(eigenVectors, k);
            % Return the labels
            result = self.Labels;
        end


        function result = cluster_random_walk(self)
            % Performs clustering using random walk approach

            % Obtain the inverse of degree matrix
            dec_inv = self.DegreeVec.^-1;
            % take care of 0 terms in degree vector
            dec_inv(self.DegreeVec == 0) = 0;
            deg_inverse = diag(dec_inv);
            n = self.N;
            % Compute the Laplacian
            self.Laplacian = speye(n) - deg_inverse * self.W;
            % fprintf('Computing SVD of the Graph Laplacian\n');
            % Number of clusters
            k = self.NumClusters;
            % number of eigen vectors needed
            nev = self.MaxClusters;
            if k > 0 
                nev = k;
            end
            % Perform singular value decomposition of the normalized laplacian
            % and identify the eigen vectors corresponding to smallest singular values
            %[~, S, V] = svds(self.Laplacian, nev, 0);
            tstart = tic;
            [~, S, V] = svd(self.Laplacian);
            self.SVDTime = toc(tstart);
            self.SingularValues = diag(S);
            self.EigenVectors = V;
            if k < 0
                if self.Debug
                    fprintf('Estimating number of clusters by rotating eigen vectors\n');
                end
                self.find_clusters_from_eig_vectors();
                result = self.Labels;
                return;
            end
            % Number of clusters must be less than the number of points.
            assert(k <= n);
            eigenVectors = V(:,n-k+1:n);
            % Run k-means clustering on chosen eigen vectors
            self.cluster_eigen_vectors(eigenVectors, k);
            % Return the labels
            result = self.Labels;
            if self.Debug
                result'
            end
        end


        function result = cluster_symmetric(self)
            % Performs clustering using normalized symmetric graph laplacian

            % Obtain the inverse of degree matrix
            deg_inverse_half = diag(self.DegreeVec.^-(1/2));
            n = self.N;
            % Compute the Laplacian
            self.Laplacian = speye(n) - deg_inverse_half * self.W * deg_inverse_half;
            % Perform singular value decomposition of the normalized laplacian
            [~, S, V] = svd(self.Laplacian);
            self.SingularValues = diag(S);
            self.EigenVectors = V;
            % Number of clusters
            k = self.NumClusters;
            if k < 0
                self.find_clusters_from_eig_vectors();
                result = self.Labels;
                return;
            end
            % Number of clusters must be less than the number of points.
            assert(k <= n);
            eigenVectors = V(:,n-k+1:n);
            self.cluster_eigen_vectors(eigenVectors, k);
            % Return the labels
            result = self.Labels;
        end

    end


    methods(Access=private)
        function find_clusters_from_eig_vectors(self)
            % Finds out the number of clusters from the changes in singular values
            S = self.SingularValues;
            X = self.EigenVectors;
            vr = SPX_SCEigVecRot(X, S);
            vr.Debug = self.Debug;
            if self.MaxClusters > 0
                vr.MaxClusters = self.MaxClusters;
            end
            [num_clusters, labels] = vr.estimate_clusters();
            if self.Debug
            end
            self.Labels = labels;
            self.NumClusters = num_clusters;
        end


        function cluster_eigen_vectors(self, eigen_vectors, k)
            tstart = tic;
            self.cluster_kmeans(eigen_vectors, k);
            %self.cluster_kmeans_pp(eigen_vectors, k);
            self.KMeansTime = toc(tstart);
        end

        function cluster_kmeans(self, eigen_vectors, k)
            eigen_vectors = SPX_Norm.normalize_l2_rw(eigen_vectors);
            n = self.N;
            % eigen vectors matrix is of size [n, k]
            % k seeds are needed
            % one seed matrix is of size [k, k].

            % Choose initial seed vectors by kmeans plus-plus algorithm
            all_seeds = zeros(k, k, 0);
            for i=1:self.Replications
                [seeds, labels] = SPX_KMeans.pp_initialize(eigen_vectors', k);
                all_seeds(:, :, end+1) = seeds';
            end
            [seeds, labels] = SPX_KMeans.pp_initialize(eigen_vectors', k);
            self.Labels = kmeans(eigen_vectors, k, ...
                'start', all_seeds, ...
                'maxiter',self.MAXiter, ...
                'EmptyAction','singleton');
        end

        function cluster_kmeans_pp(self, eigen_vectors, k)
            self.Labels = kmeanspp(eigen_vectors', k)';
        end
    end

    methods(Static)



    end
end
