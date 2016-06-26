
close all; clear all; clc;
yf = spx.data.image.EhsanYaleFaces();
[faces, sizes, labels] = yf.all_faces();
% normalize the faces
faces_normalized = spx.commons.norm.normalize_l2(faces);
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
tabulate(fioas);


mf  = spx.graphics.Figures;
mf.new_figure;
subplot(331);
hist(angle_result.within_neighbor_counts);
title('Within Neighbors');
subplot(332);
hist(angle_result.within_minimum_angles);
title('Within Minimum Angles');
subplot(333);
hist(angle_result.within_maximum_angles);
title('Within Maximum Angles');
subplot(334);
hist(angle_result.nearst_within_neighbor_indices);
title('Within Nearest Indices');
subplot(335);
hist(angle_result.nearst_outside_neighbor_indices);
title('Outside Nearest Indices');
subplot(336);
hist(angle_result.outside_nearest_neighbor_angles);
title('Outside Nearest Angles');
subplot(337);
hist(angle_result.first_in_out_angle_spreads);
title('First In/Out angle spreads');
subplot(338);
subplot(339);
