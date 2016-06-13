close all; clear all; clc;


resize_images = false;
load bin/omp_representations;
ni = 50;
fprintf('Computing angles between subspaces');
tstart = tic;
angles = spx.la.spaces.smallest_angles_deg(representations(1:end, :), ni);
elapsed = toc(tstart);
off_diag_angles = SPX_Mat.off_diag_upper_tri_elements(angles);
off_diag_angles = sort(off_diag_angles);
minimum_angle = min(off_diag_angles);
maximum_angle = max(off_diag_angles);
fprintf('Time taken: %.2f seconds \n', elapsed);
fprintf('Angles between subspaces (degrees): \n');
disp(angles);
fprintf('Minimum angle: %.2f degrees\n\n', minimum_angle);
fprintf('Maximum angle: %.2f degrees\n\n', maximum_angle);
save ('bin/omp_rep_principal_angles','angles', 'off_diag_angles');

