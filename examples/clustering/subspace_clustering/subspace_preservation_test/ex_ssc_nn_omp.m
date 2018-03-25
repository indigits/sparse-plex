clear all;
close all;
clc;
spx.cluster.ssc.util.simulate_subspace_preservation(@ssc_nn_omp, 'ssc_nn_omp');
spx.cluster.ssc.util.print_subspace_preservation_results('ssc_nn_omp');
