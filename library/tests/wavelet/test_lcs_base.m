function tests = test_lcs_base
  tests = functiontests(localfunctions);
end

function test_psi(testCase)
    x = -0.5:.01:.5;
    epsilon = .1;
    psi_a = spx.wavelet.lcs.psi(epsilon, x);
    psi_b = spx.wavelet.lcs.psi(epsilon, -x);
    verifyEqual(testCase, psi_a, psi_b, 'RelTol', 0.01);
end

function test_theta(testCase)
    x = -0.5:.01:.5;
    epsilon = .1;
    theta_a = spx.wavelet.lcs.theta(epsilon, x);
    theta_b = spx.wavelet.lcs.theta(epsilon, -x);
    verifyEqual(testCase, theta_a + theta_b, pi/2*ones(size(theta_a)), 'RelTol', 0.01);
end


function test_eps(testCase)
    x = -0.5:.01:.5;
    epsilon = .45;
    c_e = spx.wavelet.lcs.c_eps(epsilon, x);
    s_e = spx.wavelet.lcs.s_eps(epsilon, -x);
    verifyEqual(testCase, c_e, s_e, 'AbsTol', 1e-6);
    s_e = spx.wavelet.lcs.s_eps(epsilon, x);
    verifyEqual(testCase, c_e.^2 + s_e.^2, 1*ones(size(x)), 'RelTol', 0.01);
end

