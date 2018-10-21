function tests = test_haar
  tests = functiontests(localfunctions);
end

function test_qmf(testCase)
    f = spx.wavelet.haar.quad_mirror_filter();
    verifyTrue(testCase, spx.norm.is_unit_norm_vec(f));
end

