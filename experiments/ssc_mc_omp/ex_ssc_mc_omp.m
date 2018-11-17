clear all;
close all;
clc;
rng default;
config =  create_config([2 2 2 2 2 2], 4, '2-4');
spx.cluster.ssc.util.simulate_subspace_preservation(@ssc_mc_omp, 'ssc_mc_omp', config);
spx.cluster.ssc.util.print_subspace_preservation_results('ssc_mc_omp');
