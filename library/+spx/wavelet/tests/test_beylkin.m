function test_suite = test_beylkin
  initTestSuite;
end

function test_qmf
    f = SPX_BeylkinWavelet.quad_mirror_filter();
    assertTrue(SPX_Norm.is_unit_norm_vec(f));
end

