clearvars;
close all;
clc;
spx.cluster.ssc.util.simulate_subspace_preservation(@ssc_l1_mahdi, 'ssc_l1_mahdi');
spx.cluster.ssc.util.print_subspace_preservation_results('ssc_l1_mahdi');
