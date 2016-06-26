clear all;
close all;
clc;
results = cell(1, 3);
results{1} = merge_results('ssc_omp');
results{2} = merge_results('ssc_nn_omp');
results{3} = merge_results('ssc_tomp');
plot_bench_multiple_results(results, ...
    {'ssc_omp', 'ssc_nn_omp', 'ssc_tomp'}, ...
    {'SSC-OMP', 'SSC-NN-OMP', 'SSC-TOMP'});


