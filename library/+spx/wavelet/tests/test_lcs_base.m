function test_suite = test_lcs_base
  initTestSuite;
end

function test_psi
    x = -0.5:.01:.5;
    epsilon = .1;
    psi_a = SPX_LCSBase.psi(epsilon, x);
    psi_b = SPX_LCSBase.psi(epsilon, -x);
    assertElementsAlmostEqual(psi_a, psi_b);
end

function test_theta
    x = -0.5:.01:.5;
    epsilon = .1;
    theta_a = SPX_LCSBase.theta(epsilon, x);
    theta_b = SPX_LCSBase.theta(epsilon, -x);
    assertElementsAlmostEqual(theta_a + theta_b, pi/2*ones(size(theta_a)));
end


function test_eps
    x = -0.5:.01:.5;
    epsilon = .45;
    c_e = SPX_LCSBase.c_eps(epsilon, x);
    s_e = SPX_LCSBase.s_eps(epsilon, -x);
    assertElementsAlmostEqual(c_e, s_e);
    s_e = SPX_LCSBase.s_eps(epsilon, x);
    assertElementsAlmostEqual(c_e.^2 + s_e.^2, 1*ones(size(x)));
end

