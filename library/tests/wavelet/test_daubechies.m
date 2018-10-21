function tests = test_daubechies
  tests = functiontests(localfunctions);
end

function test_qmf(testCase)
    f = spx.wavelet.daubechies.quad_mirror_filter(4);
    verifyTrue(testCase, spx.norm.is_unit_norm_vec(f));
    f = spx.wavelet.daubechies.quad_mirror_filter(6);
    verifyTrue(testCase, spx.norm.is_unit_norm_vec(f));
    f = spx.wavelet.daubechies.quad_mirror_filter(8);
    verifyTrue(testCase, spx.norm.is_unit_norm_vec(f));
    f = spx.wavelet.daubechies.quad_mirror_filter(10);
    verifyTrue(testCase, spx.norm.is_unit_norm_vec(f));
    f = spx.wavelet.daubechies.quad_mirror_filter(12);
    verifyTrue(testCase, spx.norm.is_unit_norm_vec(f));
    f = spx.wavelet.daubechies.quad_mirror_filter(14);
    verifyTrue(testCase, spx.norm.is_unit_norm_vec(f));
    f = spx.wavelet.daubechies.quad_mirror_filter(16);
    verifyTrue(testCase, spx.norm.is_unit_norm_vec(f));
    f = spx.wavelet.daubechies.quad_mirror_filter(18);
    verifyTrue(testCase, spx.norm.is_unit_norm_vec(f));
    f = spx.wavelet.daubechies.quad_mirror_filter(20);
end

