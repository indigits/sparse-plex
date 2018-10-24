clc;
clearvars;
close all;
rng default;

basis = orth(randn(3, 2))
basis'*basis

rng(10);
A = orth(randn(3, 2))
e1 = A(:, 1);
e2 = A(:, 2);
corners = [e1+e2, e2-e1, -e1-e2, -e2+e1];
spx.graphics.figure.full_screen;
fill3(corners(1,:),corners(2,:),corners(3,:),'r');
grid on;
hold on;
alpha(0.3);
quiver3(0, 0, 0, e1(1), e1(2), e1(3), 'color', 'r');
quiver3(0, 0, 0, e2(1), e2(2), e2(3), 'color', 'r');
saveas(gcf, 'images/random_subspace_a_3d.png');
rng(30);
B = orth(randn(3, 2));
e1 = B(:, 1);
e2 = B(:, 2);
corners = [e1+e2, e2-e1, -e1-e2, -e2+e1];
fill3(corners(1,:),corners(2,:),corners(3,:),'g');
alpha(0.3);
quiver3(0, 0, 0, e1(1), e1(2), e1(3), 'color', spx.graphics.rgb('DarkGreen'));
quiver3(0, 0, 0, e2(1), e2(2), e2(3), 'color', spx.graphics.rgb('DarkGreen'));
saveas(gcf, 'images/random_subspace_a_b_3d.png');


% subspace dimension
D = 4;
% ambient dimension
M = 10;
% Number of subspaces
K = 2;
import spx.data.synthetic.subspaces.random_subspaces;
bases = random_subspaces(M, K, D);
A = bases{1};
B = bases{2};
G = A' * B
sigmas = svd(G)'
largest_product = sigmas(1)
smallest_angle_rad  = acos(largest_product)
smallest_angle_deg = rad2deg(smallest_angle_rad)