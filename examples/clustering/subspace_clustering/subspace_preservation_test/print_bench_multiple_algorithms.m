clear all;
close all;
clc;
results = {};
results{1} = merge_results('ssc_omp');
results{2} = merge_results('ssc_mc_omp');
%results{3} = merge_results('ssc_tomp');
%results{4} = merge_results('ssc_l1');
plot_bench_multiple_results(results, ...
    {'ssc_omp', 'ssc_mc_omp'}, ...
    {'SSC-OMP', 'SSC-MC-OMP'});



