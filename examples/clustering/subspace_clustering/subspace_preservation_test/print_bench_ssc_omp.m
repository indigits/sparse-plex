clear all;
close all;
clc;
result = merge_results('ssc_omp');
plot_bench_results(result, 'ssc_omp');
