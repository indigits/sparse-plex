function test_suite = test_coiflet
  initTestSuite;
end

function test_qmf
    f = SPX_Coiflet.quad_mirror_filter(1);
    assertTrue(spx.commons.norm.is_unit_norm_vec(f));
    f = SPX_Coiflet.quad_mirror_filter(2);
    assertTrue(spx.commons.norm.is_unit_norm_vec(f));
    f = SPX_Coiflet.quad_mirror_filter(3);
    assertTrue(spx.commons.norm.is_unit_norm_vec(f));
    f = SPX_Coiflet.quad_mirror_filter(4);
    assertTrue(spx.commons.norm.is_unit_norm_vec(f));
    f = SPX_Coiflet.quad_mirror_filter(5);
    assertTrue(spx.commons.norm.is_unit_norm_vec(f));
end

