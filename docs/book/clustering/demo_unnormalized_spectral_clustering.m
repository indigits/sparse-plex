close all;
clearvars;
clc;
W = [ones(4) zeros(4); zeros(4) ones(4)]
[num_nodes, ~] = size(W);
true_labels = [1 1 1 1 2 2 2 2];
Degree = diag(sum(W))
Laplacian = Degree - W
[~, S, V] = svd(Laplacian);
singular_values = diag(S);
fprintf('Singular values: \n');
spx.io.print.vector(singular_values);
figure;
plot(singular_values, 'ro-');
saveas(gcf, 'images/simple_unnormalized_singular_values.png');
sv_changes = diff( singular_values(1:end-1) );
spx.io.print.vector(sv_changes);
[min_val , ind_min ] = min(sv_changes)
num_clusters = num_nodes - ind_min
% Choose the last num_clusters eigen vectors
Kernel = V(:,num_nodes-num_clusters+1:num_nodes);

% Maximum iteration for KMeans Algorithm
max_iterations = 1000; 
% Replication for KMeans Algorithm
replicates = 100;
labels = kmeans(Kernel, num_clusters, ...
    'start','sample', ...
    'maxiter',max_iterations,...
    'replicates',replicates, ...
    'EmptyAction','singleton'...
    );
spx.io.print.vector(labels, 0);
