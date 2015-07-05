function test_suite = test_beylkin
  initTestSuite;
end

function test_on_qmf
    f = SPX_BeylkinWavelet.on_qmf_filter();
    assertTrue(SPX_Norm.is_unit_norm_vec(f));
end

