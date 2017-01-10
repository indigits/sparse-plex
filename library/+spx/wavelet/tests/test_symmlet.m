function test_suite = test_symmlet
  initTestSuite;
end

function test_qmf
    f = SPX_Symmlet.quad_mirror_filter(4);
    assertTrue(spx.norm.is_unit_norm_vec(f));
    f = SPX_Symmlet.quad_mirror_filter(5);
    assertTrue(spx.norm.is_unit_norm_vec(f));
    f = SPX_Symmlet.quad_mirror_filter(6);
    assertTrue(spx.norm.is_unit_norm_vec(f));
    f = SPX_Symmlet.quad_mirror_filter(7);
    assertTrue(spx.norm.is_unit_norm_vec(f));
    f = SPX_Symmlet.quad_mirror_filter(8);
    assertTrue(spx.norm.is_unit_norm_vec(f));
    f = SPX_Symmlet.quad_mirror_filter(9);
    assertTrue(spx.norm.is_unit_norm_vec(f));
    f = SPX_Symmlet.quad_mirror_filter(10);
    assertTrue(spx.norm.is_unit_norm_vec(f));
end

