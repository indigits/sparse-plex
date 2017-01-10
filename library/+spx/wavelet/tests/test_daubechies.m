function test_suite = test_daubechies
  initTestSuite;
end

function test_qmf
    f = SPX_DaubechiesWavelet.quad_mirror_filter(4);
    assertTrue(spx.norm.is_unit_norm_vec(f));
    f = SPX_DaubechiesWavelet.quad_mirror_filter(6);
    assertTrue(spx.norm.is_unit_norm_vec(f));
    f = SPX_DaubechiesWavelet.quad_mirror_filter(8);
    assertTrue(spx.norm.is_unit_norm_vec(f));
    f = SPX_DaubechiesWavelet.quad_mirror_filter(10);
    assertTrue(spx.norm.is_unit_norm_vec(f));
    f = SPX_DaubechiesWavelet.quad_mirror_filter(12);
    assertTrue(spx.norm.is_unit_norm_vec(f));
    f = SPX_DaubechiesWavelet.quad_mirror_filter(14);
    assertTrue(spx.norm.is_unit_norm_vec(f));
    f = SPX_DaubechiesWavelet.quad_mirror_filter(16);
    assertTrue(spx.norm.is_unit_norm_vec(f));
    f = SPX_DaubechiesWavelet.quad_mirror_filter(18);
    assertTrue(spx.norm.is_unit_norm_vec(f));
    f = SPX_DaubechiesWavelet.quad_mirror_filter(20);
end

