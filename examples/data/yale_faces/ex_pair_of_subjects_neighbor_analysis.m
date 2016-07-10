close all; clear all; clc;
yf = spx.data.image.EhsanYaleFaces();
[faces, sizes, labels] = yf.all_faces();
% normalize the faces
faces_normalized = spx.commons.norm.normalize_l2(faces);
[M, S]  = size(faces_normalized);

% only between 2 subjects
% interesting cases are (10, 11), (28, 29), (29, 30)
% (35, 36), (36, 37)
s1 = 35;
s2 = s1+1;
columns_s1 = (1:64) + (s1-1)*64;
columns_s2 = (1:64) + (s2-1)*64;
all_columns = [columns_s1 columns_s2];
fprintf('\n\n\n Statistics for the first pair of subjects:\n\n');
faces_normalized = faces_normalized(:, all_columns);
[M, S]  = size(faces_normalized);
sizes = [64 64];
angle_result = spx.cluster.subspace.nearest_same_subspace_neighbors_by_inner_product(faces_normalized, sizes);


fprintf('Within Neighbor Counts:\n %s\n', spx.stats.format_descriptive_statistics(angle_result.within_neighbor_counts));
fprintf('Nearest Within Neighbor Indices:\n %s\n', spx.stats.format_descriptive_statistics(angle_result.nearst_within_neighbor_indices));
nearst_within_neighbor_indices = angle_result.nearst_within_neighbor_indices;
% club all those cases where nearest within neighbor is far away.
nearst_within_neighbor_indices(nearst_within_neighbor_indices > 5) = -1;
tabulate(nearst_within_neighbor_indices);
fprintf('First In Out Angle Spreads:\n %s\n', spx.stats.format_descriptive_statistics(angle_result.first_in_out_angle_spreads));
fioas = angle_result.first_in_out_angle_spreads;
%fioas = round(fioas * 10) / 10;
fioas = round(fioas/4)*4;
fioas(fioas > 8) = 100;
fioas(fioas < -8) = 100;
angle_gt_zero_flags = angle_result.first_in_out_angle_spreads >= 0;
angle_gte_zero = angle_result.first_in_out_angle_spreads(angle_gt_zero_flags);
angle_lte_two_flags =  angle_gte_zero <= 2;
angle_lte_four_flags =  angle_gte_zero <= 4;
angle_lte_eight_flags =  angle_gte_zero <= 8;
angle_lt_zero_flags = angle_result.first_in_out_angle_spreads < 0;
angle_lt_zero =  angle_result.first_in_out_angle_spreads(angle_lt_zero_flags);
angle_gte_minus_two_flags =  angle_lt_zero >= -2;
angle_gte_minus_four_flags =  angle_lt_zero >= -4;
abs_angle_lte_four_flags = abs(angle_result.first_in_out_angle_spreads) <=4;
fprintf('angle greater than equal to 0: %.2f %%\n', sum(angle_gt_zero_flags) * 100 / S);
fprintf('angle less than 2: %.2f %%\n', sum(angle_lte_two_flags) * 100 / S);
fprintf('angle less than 4: %.2f %%\n', sum(angle_lte_four_flags) * 100 / S);
fprintf('angle less than 8: %.2f %%\n', sum(angle_lte_four_flags) * 100 / S);
fprintf('angle less than 0: %.2f %%\n', sum(angle_lt_zero_flags) * 100 / S);
fprintf('angle greater than -2: %.2f %%\n', sum(angle_gte_minus_two_flags) * 100 / S);
fprintf('angle greater than -4: %.2f %%\n', sum(angle_gte_minus_four_flags) * 100 / S);
fprintf('abs angle less than 4: %.2f %%\n', sum(abs_angle_lte_four_flags) * 100 / S);
