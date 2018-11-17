clear all;
close all;
clc;
fprintf('Merging results from all experiments: \n');
result = spx.cluster.ssc.util.merge_bench_subspace_preservation_results('ssc_omp');
fprintf('Plotting the results: \n');
plot_bench_results(result, 'ssc_omp');
