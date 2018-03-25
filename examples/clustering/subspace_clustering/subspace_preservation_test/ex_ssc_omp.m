clear all;
close all;
clc;
spx.cluster.ssc.util.simulate_subspace_preservation(@ssc_omp, 'ssc_omp');
spx.cluster.ssc.util.print_subspace_preservation_results('ssc_omp');
