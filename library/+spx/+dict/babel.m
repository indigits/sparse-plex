function [ babel ] = babel( Phi )
%BABEL computes the Babel function of a dictionary
% Columns of Phi must be unit norm
% The function has been defined by Joel A Tropp

% Let us compute the Gram matrix
G = Phi' * Phi;
% Let us take element wise absolute
absG = abs(G);
% Let us sort each row in descending order
GS = sort(absG, 2,'descend');
rowSums = cumsum(GS(:, 2:end), 2);
babel = max(rowSums);


