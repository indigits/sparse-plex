close all;
clc;
clearvars;
rng(11);

basis = orth(randn(3, 2));
e1 = basis(:, 1);
e2 = basis(:, 2);
corners = [e1+e2, e2-e1, -e1-e2, -e2+e1];
spx.graphics.figure.full_screen;
fill3(corners(1,:),corners(2,:),corners(3,:),'r');
grid on;
hold on;
alpha(0.3);
% unit vectors 
quiver3(0, 0, 0, e1(1), e1(2), e1(3), 'color', 'blue');
quiver3(0, 0, 0, e2(1), e2(2), e2(3), 'color', 'blue');
num_points = 100;
coefficients = randn(2, num_points);
coefficients = spx.norm.normalize_l2(coefficients);
uniform_points = basis * coefficients;
x = uniform_points(1, :);
y = uniform_points(2, :);
z = uniform_points(3, :);
plot3(x, y, z, '.', 'color', spx.graphics.rgb('Brown') );
% plot the origin too
plot3(0, 0, 0, '+k', 'MarkerSize', 10, 'color', spx.graphics.rgb('DarkRed'));
saveas(gcf, 'images/uniform_points_2d_subspace.png');