clear all;
close all;
clc;
config =  create_config([2 2 2 2 2 2], 8, '2-8');
simulate_subspace_preservation(@ssc_mc_omp, 'ssc_mc_omp', config);
