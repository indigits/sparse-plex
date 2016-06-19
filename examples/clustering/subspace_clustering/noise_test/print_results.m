function print_results(filepath)
load(filepath);
true_labels = spx.cluster.labels_from_cluster_sizes(Ss);
for r=1:R
    sigma = noise_sigma_levels(r);
    cluster_labels = estimated_labels{r};
    singular_values = estimated_singular_values{r};
    Z = estimated_coefficients{r};
    num_clusters = estimated_num_subspaces(r);
    fprintf('Noise  level: %0.2f, clusters: %d, success: %d', sigma, num_clusters, num_clusters == K);
    % Time to compare the clustering
    comparer = spx.cluster.ClusterComparison(true_labels, cluster_labels);
    result = comparer.fMeasure();
    fprintf(' F-measure: %.2f\n', result.fMeasure);
end


end

