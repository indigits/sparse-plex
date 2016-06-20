function tests = test_subspaces()
  tests = functiontests(localfunctions);
end

function test_affinity(testCase)
    N = 4;
    theta = pi/4;
    [A, B] = spx.data.synthetic.subspaces.two_spaces_at_angle(N, theta);
    verifyTrue(testCase, spx.commons.matrix.is_orthonormal(A));
    verifyTrue(testCase, spx.commons.matrix.is_orthonormal(B));
    phi = spx.la.spaces.smallest_angle_rad(A, B);
    verifyEqual (testCase, phi, theta, 'AbsTol', 1e-12);
    thetas = spx.la.spaces.principal_angles_degree(A, B);
    affinity = spx.cluster.subspace.affinity(A, B);
    verifyEqual(testCase, affinity, 0.223130160148430, 'AbsTol', 1e-12);
end
