W = [ones(4) zeros(4); zeros(4) ones(4)];
num_clusters = 2;
labels = [1 1 1 1 2 2 2 2];
singular_values = [4 4 4 4 4 4 0 0]';
spx.cluster.spectral.simple.unnormalized(W);
