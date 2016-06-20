close all; clear all; clc;


resize_images = false;

yf = spx.data.image.YaleFaces();
yf.load();

ns = yf.num_subjects();
ni = yf.ImagesToLoadPerSubject;
fprintf('Computing angles between subspaces');
tstart = tic;
Y = yf.ImageData;
means = mean(Y);
%Y = bsxfun(@minus, Y, means);

angles = spx.la.spaces.smallest_angles_deg(Y, ni);
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
save ('bin/principal_angles','angles', 'off_diag_angles');

