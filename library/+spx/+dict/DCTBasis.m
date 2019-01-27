classdef DCTBasis < spx.dict.Operator 

properties(SetAccess=private)
    % Dimensions
    N
end

methods

function self = DCTBasis(N)
    if nargin < 1
        error('Basis dimensions must be specified');
    end
    self.N = N;
end

function [mm, nn]  = get_size(self)
    mm = self.N;
    nn = self.N;
end

function result = apply(self, vectors)
    if size(vectors, 1) ~= self.N
        error('Dimensions mismatch');
    end
    result = idct(vectors);
end

function result = apply_ctranspose(self, vectors)
    if size(vectors, 1) ~= self.N
        error('Dimensions mismatch');
    end
    result = dct(vectors);
end

function result = double(self)
    % Converts the operator into a MATRIX
    n = self.N;
    result = zeros(n);
    for i=1:n
        x = zeros(n, 1);
        x(i) = 1;
        result(:, i) = self.apply(x);
    end
end


function result = norm(self)
    result = 1;
end

end

end
