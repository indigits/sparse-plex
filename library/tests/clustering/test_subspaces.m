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


function test_subspace_preserving_representations(testCase)
    cluster_sizes = [4 4];
    C = [
    0 1 1 1 0 0 0 0 
    1 0 0 1 0 0 0 0
    1 1 0 0 0 0 0 0
    1 0 1 0 0 0 0 0
    0 0 0 0 0 1 1 1
    0 0 0 0 1 0 0 1
    0 0 0 0 1 1 0 0
    0 0 0 0 1 0 1 0
    ];
    % We construct a subspace preserving representation
    C = C';
    result = spx.cluster.subspace.subspace_preservation_stats(C, cluster_sizes);
    verifyEqual(testCase, result.spr_errors, [0 0 0 0 0 0 0 0]);
    verifyEqual(testCase, result.spr_error, 0);
    verifyEqual(testCase, result.spr_flags, [1 1 1 1 1 1 1 1]);
    verifyEqual(testCase, result.spr_flag, true);
    verifyEqual(testCase, result.spr_component, 1);
    verifyEqual(testCase, result.spr_perc, 100);


    C = [
    0 1 1 1 0 0 1 0 
    1 0 0 1 0 0 0 0
    1 1 0 0 0 0 0 0
    1 0 1 0 0 0 0 0
    0 0 0 0 0 1 1 1
    0 0 0 0 1 0 0 1
    0 1 0 0 1 1 0 0
    0 0 0 0 1 0 1 0
    ];
    % We construct a subspace preserving representation
    C = C';
    result = spx.cluster.subspace.subspace_preservation_stats(C, cluster_sizes);
    verifyEqual(testCase, result.spr_errors, [1/4 0 0 0 0 0 1/3 0], 'AbsTol', 1e-12);
    verifyEqual(testCase, result.spr_error, (1/4 + 1/3)/8, 'AbsTol', 1e-12);
    verifyEqual(testCase, result.spr_flags, [0 1 1 1 1 1 0 1]);
    verifyEqual(testCase, result.spr_flag, false);
    verifyEqual(testCase, result.spr_component, 3/4);
    verifyEqual(testCase, result.spr_perc, 75);
end


function test_nearest_same_subspace_neighbors_by_inner_product(testCase)
    N = 4;
    theta = pi/100;
    [A, B] = spx.data.synthetic.subspaces.two_spaces_at_angle(N, theta);
    % create vectors from both subspaces
    Sk = 10;
    XA = A * randn(N/2, Sk);
    XB = B * randn(N/2, Sk);
    X = [XA XB];
    % normalize columns
    X = spx.norm.normalize_l2(X);
    result = spx.cluster.subspace.nearest_same_subspace_neighbors_by_inner_product(X, [Sk Sk])
end