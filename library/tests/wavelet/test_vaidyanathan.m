function tests = test_vaidyanathan
  tests = functiontests(localfunctions);
end

function test_qmf(testCase)
    f = spx.wavelet.vaidyanathan.quad_mirror_filter();
    verifyTrue(testCase, spx.norm.is_unit_norm_vec(f));
end

