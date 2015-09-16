function test_suite = test_sparse_sig_gen
  initTestSuite;
end


function test_uniform
    N = 10;
    K = 4;
    S = 1;
    gen  = SPX_SparseSignalGenerator(N, K, S);
    a = 1;
    b = 2;
    result = gen.uniform(a, b);
    omega = gen.Omega;
    nz_part = result(omega);
    assertTrue(all(nz_part <= b));
    assertTrue(all(nz_part >= a));
end


function test_real_spherical_rows
    N = 10;
    K = 4;
    S = 20;
    gen  = SPX_SparseSignalGenerator(N, K, S);
    result = gen.real_spherical_rows;
    omega = gen.Omega;
    nz_part = result(omega, :);    
    % verify that all rows have unit norm
    norms = SPX_Norm.norms_l2_rw(nz_part);
    assertElementsAlmostEqual(norms, ones(K, 1));
end


function test_cmplx_spherical_rows
    N = 10;
    K = 4;
    S = 20;
    gen  = SPX_SparseSignalGenerator(N, K, S);
    result = gen.complex_spherical_rows;
    omega = gen.Omega;
    nz_part = result(omega, :);    
    % verify that all rows have unit norm
    norms = SPX_Norm.norms_l2_rw(nz_part);
    assertElementsAlmostEqual(norms, ones(K, 1));
end
