function tests = test_spaces
  tests = functiontests(localfunctions);
end


function test_orth_complement(testCase)
    M = 100;
    N1 = 10;
    N2 = 10;
    N = N1 + N2;
    X = randn(M, N) ./ sqrt(M);
    A = X(:, 1:N1);
    B = X(:, N1+1:end);
    C = spx.la.spaces.orth_complement(A, B);
    D = A' * C;
    verifyEqual(testCase, D, zeros(size(D)), 'AbsTol', 1e-6);

end