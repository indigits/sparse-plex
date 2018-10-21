function tests = test_symmlet
  tests = functiontests(localfunctions);
end

function test_qmf(testCase)
    f = spx.wavelet.symm.quad_mirror_filter(4);
    verifyTrue(testCase, spx.norm.is_unit_norm_vec(f));
    f = spx.wavelet.symm.quad_mirror_filter(5);
    verifyTrue(testCase, spx.norm.is_unit_norm_vec(f));
    f = spx.wavelet.symm.quad_mirror_filter(6);
    verifyTrue(testCase, spx.norm.is_unit_norm_vec(f));
    f = spx.wavelet.symm.quad_mirror_filter(7);
    verifyTrue(testCase, spx.norm.is_unit_norm_vec(f));
    f = spx.wavelet.symm.quad_mirror_filter(8);
    verifyTrue(testCase, spx.norm.is_unit_norm_vec(f));
    f = spx.wavelet.symm.quad_mirror_filter(9);
    verifyTrue(testCase, spx.norm.is_unit_norm_vec(f));
    f = spx.wavelet.symm.quad_mirror_filter(10);
    verifyTrue(testCase, spx.norm.is_unit_norm_vec(f));
end

