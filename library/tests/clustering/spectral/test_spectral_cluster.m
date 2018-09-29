function tests = test_spectral_cluster
  tests = functiontests(localfunctions);
end

function test_gaussian_values(testCase)
    points_per_set = 100;
    % number of clusters
    num_clusters = 8;
    % points 
    points = [];
    gap = 2;
    true_labels = zeros(points_per_set*num_clusters, 1);
    fprintf('Creating data points\n');
    for c=1:num_clusters
        mean_val = c * gap;
        % values random between 0 and 1
        point_set = rand(1, points_per_set);
        % shift between -gap / 4 and  gap / 4
        point_set = point_set * gap / 2 - gap/4;
        % then move to mean
        point_set = point_set + mean_val;
        % add to the list of all points
        points = [points point_set];
        true_labels((c - 1)*points_per_set + (1:points_per_set)) = c;
    end
    fprintf('Computing distance matrix\n');
    % prepare the distance matrix
    dist_matrix = spx.commons.distance.pairwise_distances(points);
    fprintf('Computing similarity matrix\n');
    % prepare the Gaussian similarity matrix
    % Eigen values have a large impact based on the choice of sigma
    % The lower variance, the closure first num_clusters are to zero.
    % At high variance like sigma=2.5, we completely lose out on clustering accuracy 
    sigma = .5;
    sim_matrix = spx.cluster.similarity.gaussian_similarity(dist_matrix, sigma);
    % lets see the impact of filtering the similarity matrix
    % sim_matrix = spx.cluster.similarity.filter_k_nearest_neighbors(sim_matrix, points_per_set*1.5);

    % We can now run spectral clustering on it
    fprintf('Initializing spectral clustering algorithm for unnormalized laplacian\n');
    clusterer = spx.cluster.spectral.Clustering(sim_matrix);
    clusterer.NumClusters = num_clusters;
    fprintf('Performing clustering for unnormalized laplacian\n');
    cluster_labels = clusterer.cluster_unnormalized();
    combined_labels = [true_labels cluster_labels]';
    % We can print the singular values if required.
    singular_values = clusterer.SingularValues';
    % singular_values(end - num_clusters - 4:end);
    % Time to compare the clustering
    comparer = spx.cluster.ClusterComparison(true_labels, cluster_labels);
    result = comparer.fMeasure();
    verifyEqual(testCase, result.fMeasure, 1.0);


    % Perform spectral clustering using random walk  version of graph laplacian
    fprintf('Initializing spectral clustering algorithm for random walk version\n');
    clusterer = spx.cluster.spectral.Clustering(sim_matrix);
    clusterer.NumClusters = num_clusters;
    fprintf('Performing clustering for random walk version\n');
    cluster_labels = clusterer.cluster_random_walk();
    combined_labels = [true_labels cluster_labels]';
    % We can print the singular values if required.
    singular_values = clusterer.SingularValues';
    % singular_values(end - num_clusters - 4:end)
    % Time to compare the clustering
    comparer = spx.cluster.ClusterComparison(true_labels, cluster_labels);
    result = comparer.fMeasure();
    verifyEqual(testCase, result.fMeasure, 1.0);

    % Perform spectral clustering using random walk  version of graph laplacian
    fprintf('Initializing spectral clustering algorithm for normalized symmetric version\n');
    clusterer = spx.cluster.spectral.Clustering(sim_matrix);
    clusterer.NumClusters = num_clusters;
    fprintf('Performing clustering for normalized symmetric version\n');
    cluster_labels = clusterer.cluster_symmetric();
    combined_labels = [true_labels cluster_labels]';
    % We can print the singular values if required.
    singular_values = clusterer.SingularValues';
    %singular_values(end - num_clusters - 4:end)
    % Time to compare the clustering
    comparer = spx.cluster.ClusterComparison(true_labels, cluster_labels);
    result = comparer.fMeasure();
    verifyEqual(testCase, result.fMeasure, 1.0);
end


