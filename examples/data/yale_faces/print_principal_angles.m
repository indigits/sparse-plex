close all; clear all; clc;

export = true;

orig = load('principal_angles');
mf = SPX_Figures();
mf.new_figure('Original Principal angles');
hist(orig.off_diag_angles, 200);
xlabel('Principal angle (degrees)');
ylabel('Number of subspace pairs');
title('Distribution of principal angles over subspace pairs in signal space');
grid on;

if export
export_fig images\signal_space_principal_angles.png -r120 -nocrop;
export_fig images\signal_space_principal_angles.pdf;
end


rep = load('omp_rep_principal_angles');
mf.new_figure('Representation Principal angles');
hist(rep.off_diag_angles, 200);
xlabel('Principal angle (degrees)');
ylabel('Number of subspace pairs');
title('Distribution of principal angles over subspace pairs in representations');
grid on;

if export
export_fig images\representation_space_principal_angles.png -r120 -nocrop;
export_fig images\representation_space_principal_angles.pdf;
end

