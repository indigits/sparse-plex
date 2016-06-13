function test_suite = test_vaidyanathan
  initTestSuite;
end

function test_qmf
    f = SPX_VaidyanathanWavelet.quad_mirror_filter();
    assertTrue(spx.commons.norm.is_unit_norm_vec(f));
end

