function test_suite = test_haar
  initTestSuite;
end

function test_on_qmf
    f = SPX_HaarWavelet.on_qmf_filter();
    assertTrue(SPX_Norm.is_unit_norm_vec(f));
end

