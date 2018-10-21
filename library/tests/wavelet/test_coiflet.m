function tests = test_coiflet
  tests = functiontests(localfunctions);
end

function test_qmf(testCase)
    f = spx.wavelet.coiflet.quad_mirror_filter(1);
    verifyTrue(testCase, spx.norm.is_unit_norm_vec(f));
    f = spx.wavelet.coiflet.quad_mirror_filter(2);
    verifyTrue(testCase, spx.norm.is_unit_norm_vec(f));
    f = spx.wavelet.coiflet.quad_mirror_filter(3);
    verifyTrue(testCase, spx.norm.is_unit_norm_vec(f));
    f = spx.wavelet.coiflet.quad_mirror_filter(4);
    verifyTrue(testCase, spx.norm.is_unit_norm_vec(f));
    f = spx.wavelet.coiflet.quad_mirror_filter(5);
    verifyTrue(testCase, spx.norm.is_unit_norm_vec(f));
end

