function test_suite = test_daubechies
  initTestSuite;
end

function test_on_qmf
    f = SPX_DaubechiesWavelet.on_qmf_filter(4);
    assertTrue(SPX_Norm.is_unit_norm_vec(f));
    f = SPX_DaubechiesWavelet.on_qmf_filter(6);
    assertTrue(SPX_Norm.is_unit_norm_vec(f));
    f = SPX_DaubechiesWavelet.on_qmf_filter(8);
    assertTrue(SPX_Norm.is_unit_norm_vec(f));
    f = SPX_DaubechiesWavelet.on_qmf_filter(10);
    assertTrue(SPX_Norm.is_unit_norm_vec(f));
    f = SPX_DaubechiesWavelet.on_qmf_filter(12);
    assertTrue(SPX_Norm.is_unit_norm_vec(f));
    f = SPX_DaubechiesWavelet.on_qmf_filter(14);
    assertTrue(SPX_Norm.is_unit_norm_vec(f));
    f = SPX_DaubechiesWavelet.on_qmf_filter(16);
    assertTrue(SPX_Norm.is_unit_norm_vec(f));
    f = SPX_DaubechiesWavelet.on_qmf_filter(18);
    assertTrue(SPX_Norm.is_unit_norm_vec(f));
    f = SPX_DaubechiesWavelet.on_qmf_filter(20);
end

