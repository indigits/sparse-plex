clear all;
close all;
clc;
config =  create_config([2 2 2 2 2 2], 8, '2-8');
spx.cluster.ssc.util.simulate_subspace_preservation(@ssc_mc_omp, 'ssc_mc_omp', config);
spx.cluster.ssc.util.print_subspace_preservation_results('ssc_mc_omp');