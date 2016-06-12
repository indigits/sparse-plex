function [ mu, i, j ] = coherence( A )
%COHERENCE measures the coherence of a unit norm dictionary
% All columns of A are supposed to be unit norm.

% Examples:
% Identity matrix: coherence(eye(4))
% Orthonormalized square random matrix: coherence(orth(randn(4)))


% Let us compute the Gram matrix
G = A' * A;
% Let us take element wise absolute
absG = abs(G);
% Let us set all the diagonal elements to zero
absG(logical(eye(size(absG)))) = 0;
[mu, index] = max(absG(:));
[i, j] = ind2sub(size(G), index);
% Make sure that column numbers are reported in increasing order
if i > j
    t = i;
    i = j;
    j = t;
end
end

