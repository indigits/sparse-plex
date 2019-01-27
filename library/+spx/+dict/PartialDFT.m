classdef PartialDFT < spx.dict.Operator 

properties(SetAccess=private)
    % Dimensions
    row_pics
    col_perm
    num_rows
    num_cols
end

methods

function self = PartialDFT(row_pics, col_perm)
    if nargin < 2
        error('Row selection and column permutation must be specified');
    end
    self.row_pics = row_pics;
    self.col_perm = col_perm;
    self.num_rows = numel(row_pics);
    self.num_cols = numel(col_perm);
    if self.num_rows > self.num_cols
        error('Number of rows cannot be greater than number of columns.');
    end
end

function [mm, nn]  = get_size(self)
    mm = self.num_rows;
    nn = self.num_cols;
end

function result = apply(self, vectors)
    if size(vectors, 1) ~= self.num_cols
        error('Dimensions mismatch');
    end
    result = fft(vectors(self.col_perm, :)) / sqrt(self.num_cols);
    result = result(self.row_pics, :);
end

function result = apply_ctranspose(self, vectors)
    if size(vectors, 1) ~= self.num_rows
        error('Dimensions mismatch');
    end
    num_vectors = size(vectors, 2);
    full_vectors = zeros(self.num_cols, num_vectors);
    full_vectors(self.row_pics, :) = vectors;
    result = zeros(self.num_cols, num_vectors);
    result(self.col_perm, :) = ifft(full_vectors) * sqrt(self.num_cols);
end

function result = double(self)
    % Converts the operator into a MATRIX
    result = self.apply(eye(self.num_cols));
end


function result = norm(self)
    error('Not implemented');
end

end

end
