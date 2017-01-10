function test_suite = test_haar
  initTestSuite;
end

function test_qmf
    f = SPX_HaarWavelet.quad_mirror_filter();
    assertTrue(spx.norm.is_unit_norm_vec(f));
end

