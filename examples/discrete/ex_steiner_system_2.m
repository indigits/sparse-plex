clear all; close all; clc;
number_of_points = 10;
M = spx.discrete.steiner_system.ss_2(number_of_points);
[m, n] = size(M);
fprintf('Number of points: %d\n', m);
fprintf('Number of blocks: %d\n', n);
fprintf('Blocks:\n');
for i=1:n
    block = M(:, i);
    block = find(block == 1);
    fprintf('%d ', block);
    fprintf('\n');
end
