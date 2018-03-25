function print_subspace_preservation_results(solver_name)
filepath = sprintf('bin/subspace_preservation_test_%s.mat', solver_name);    
load(filepath);
true_labels = spx.cluster.labels_from_cluster_sizes(Ss);
for r=1:R
    rho = rhos(r);
    cluster_labels = estimated_labels{r};
    %singular_values = estimated_singular_values{r};
    Z = estimated_coefficients{r};
    num_clusters = estimated_num_subspaces(r);
    comparsion_result = comparsion_results{r};
    fprintf('Point density: %0.2f,  clusters: %d, fMeasure: %0.2f  ', rho, num_clusters, comparsion_result.fMeasure);
    if clustering_result.num_clusters == K
        fprintf('K: Success');
    else
        fprintf('K: Failure');
    end
    fprintf('\n');
end


end

