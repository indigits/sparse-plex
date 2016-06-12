function [ babel ] = babel( Phi )
%BABEL computes the Babel function of a dictionary
% Columns of Phi must be unit norm
% The function has been defined by Joel A Tropp

% Let us compute the Gram matrix
G = Phi' * Phi;
% Let us take element wise absolute
absG = abs(G);
% Let us sort each row in descending order
GS = sort(absG, 2,'descend')
numRows = size(absG, 1);
numBabelEntries = numRows-1;
babel = zeros(numBabelEntries,1);
for K=1:numBabelEntries
    rowSums = zeros(numRows, 1);
    for i = 1:numRows
        rowSums(i) = sum(GS(i, 2:K+1));
    end
    babel(K) = max(rowSums);
end


