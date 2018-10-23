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

function test_insersection_space(testCase)
    M = 100;
    N = 10;
    X =randn(M, N);
    A = [X(:, 1:4) X(:, 5:6)];
    B = [X(:, 1:4) X(:, 7:8)];
    C = spx.la.spaces.insersection_space(A, B);
    verifyEqual(testCase, rank(C), 4);
end

function test_principal_angles_orth_cos(testCase)
    M = 10;
    N = 10;
    K = N /2 ;
    X = randn(M, N);
    X = orth(X);
    A = X(:, 1:K);
    B = X(:, K+1:N);
    angles = spx.la.spaces.principal_angles_orth_cos(A, B);
    verifyEqual(testCase, angles, zeros(K, 1), 'AbsTol', 1e-6);
end

function test_two_spaces_at_angle(testCase)
    N = 50;
    theta = pi/4;
    [A, B] = spx.data.synthetic.subspaces.two_spaces_at_angle(N, theta);
    verifyTrue(testCase, spx.matrix.is_orthonormal(A));
    verifyTrue(testCase, spx.matrix.is_orthonormal(B));
    phi = spx.la.spaces.smallest_angle_rad(A, B);
    verifyEqual (testCase, phi, theta, 'AbsTol', 1e-12);
    thetas = 0.1:0.1:pi/2;
    for i=1:numel(thetas)
        theta = thetas(i);
        [A, B] = spx.data.synthetic.subspaces.two_spaces_at_angle(N, theta);
        verifyTrue(testCase, spx.matrix.is_orthonormal(A));
        verifyTrue(testCase, spx.matrix.is_orthonormal(B));
        phi = spx.la.spaces.smallest_angle_rad(A, B);
        verifyEqual (testCase, phi, theta, 'AbsTol', 1e-12);
    end
end

function test_have_same_column_spans(testCase)
    A = randn(6, 3);
    B = orth(A);
    verifyTrue(testCase, spx.la.spaces.have_same_column_spans(A, B));
    C = randn(6, 3);
    verifyFalse(testCase, spx.la.spaces.have_same_column_spans(A, C));
end

function test_three_disjoint_spaces_at_angle(testCase)
    N = 50;
    theta = pi/6;
    [A, B, C] = spx.la.spaces.three_disjoint_spaces_at_angle(N, theta);
    spx.la.spaces.describe_three_spaces(A, B, C);
    verifyTrue(testCase, spx.matrix.is_orthonormal(A));
    verifyTrue(testCase, spx.matrix.is_orthonormal(B));
    verifyTrue(testCase, spx.matrix.is_orthonormal(C));
    phi = spx.la.spaces.smallest_angle_rad(A, B);
    verifyEqual (testCase, phi, theta, 'AbsTol', 1e-12);
    phi = spx.la.spaces.smallest_angle_rad(B, C);
    verifyEqual (testCase, phi, theta, 'AbsTol', 1e-12);
    phi = spx.la.spaces.smallest_angle_rad(A, C);
    verifyEqual (testCase, phi,2*theta, 'AbsTol', 1e-12);
end
