function test_partial_basis_1d(N, M, K)

if nargin < 1
    N = 2048;
end

if nargin < 2
    M = floor(N/8);
end

if nargin < 3
    K = floor(M/5);
end

% prepare demo signal
X = spx.data.synthetic.SparseSignalGenerator()


end