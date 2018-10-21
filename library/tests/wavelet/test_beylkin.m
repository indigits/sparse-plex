function tests = test_beylkin
  tests = functiontests(localfunctions);
end

function test_qmf(testCase)
    f = spx.wavelet.baylkin.quad_mirror_filter();
    verifyTrue(testCase, spx.norm.is_unit_norm_vec(f));
end

