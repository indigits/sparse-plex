function tests = test_sparse_sig_gen
  tests = functiontests(localfunctions);
end


function test_uniform(testCase)
    N = 10;
    K = 4;
    S = 1;
    gen  = spx.data.synthetic.SparseSignalGenerator(N, K, S);
    a = 1;
    b = 2;
    result = gen.uniform(a, b);
    omega = gen.Omega;
    nz_part = result(omega);
    verifyTrue(testCase, all(nz_part <= b));
    verifyTrue(testCase, all(nz_part >= a));
end


function test_real_spherical_rows(testCase)
    N = 10;
    K = 4;
    S = 20;
    gen  = spx.data.synthetic.SparseSignalGenerator(N, K, S);
    result = gen.real_spherical_rows;
    omega = gen.Omega;
    nz_part = result(omega, :);    
    % verify that all rows have unit norm
    norms = spx.norm.norms_l2_rw(nz_part);
    verifyEqual(testCase, norms, ones(K, 1), 'AbsTol', 1e-6);
end


function test_cmplx_spherical_rows(testCase)
    N = 10;
    K = 4;
    S = 20;
    gen  = spx.data.synthetic.SparseSignalGenerator(N, K, S);
    result = gen.complex_spherical_rows;
    omega = gen.Omega;
    nz_part = result(omega, :);    
    % verify that all rows have unit norm
    norms = spx.norm.norms_l2_rw(nz_part);
    verifyEqual(testCase, norms, ones(K, 1), 'AbsTol', 1e-6);
end
