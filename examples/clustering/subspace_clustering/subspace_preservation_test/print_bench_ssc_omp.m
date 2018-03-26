clear all;
close all;
clc;
result = spx.cluster.ssc.util.merge_bench_subspace_preservation_results('ssc_omp');
plot_bench_results(result, 'ssc_omp');
