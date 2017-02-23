close all;
clear all;
clc;
rng('default');
sample_no = 101;
filename = sprintf('sample_%d.mat', sample_no);
load(filename);
Phi = spx.dict.MatrixOperator(PhiMtx);


% Solve the sparse recovery problem using OMP
matching_mode = 4;
options.norm_factor = 2;
options.VERBOSE = true;
result = ar_omp(PhiMtx, K, y, matching_mode, options);
% Solution vector
z = result.z;
stats = spx.commons.sparse.recovery_performance(Phi, K, y, x, z);
spx.commons.sparse.print_recovery_performance(stats);
fprintf('total_matched_atoms_count: %d \n',result.total_matched_atoms_count);
fprintf('Average atom index: %.2f \n',result.atom_index_average);
fprintf('\n\n\n\n');


% Solve the sparse recovery problem using OMP
matching_mode = 2;
options.VERBOSE = true;
result = ar_omp(PhiMtx, K, y, matching_mode, options);
% Solution vector
z = result.z;
stats = spx.commons.sparse.recovery_performance(Phi, K, y, x, z);
spx.commons.sparse.print_recovery_performance(stats);
fprintf('total_matched_atoms_count: %d \n',result.total_matched_atoms_count);
fprintf('Average atom index: %.2f \n',result.atom_index_average);


if 0
mf = spx.graphics.Figures();
mf.new_figure('OMP solution');
subplot(411);
stem(x, '.');
title('Sparse vector');
subplot(412);
stem(z, '.');
title('Recovered sparse vector');
subplot(413);
stem(abs(x - z), '.');
title('Recovery error');
subplot(414);
stem(y, '.');
title('Measurement vector');
end
