function test_suite = test_spx_norms
  initTestSuite;
end


function test_lp_norms
    x = [1 1 1  
         2 2 2
        3 3 3];
    assertEqual([6 6 6], SPX_Norm.norms_l1_cw(x));
    assertEqual([3 6 9]', SPX_Norm.norms_l1_rw(x));
    assertEqual(sqrt([14 14 14]), SPX_Norm.norms_l2_cw(x));
    assertEqual(sqrt([3 12 27]'), SPX_Norm.norms_l2_rw(x));
    assertEqual([3 3 3], SPX_Norm.norms_linf_cw(x));
    assertEqual([1 2 3]', SPX_Norm.norms_linf_rw(x));
    assertEqual(18, SPX_Norm.cr_l1_l1(x));
    assertEqual(18, SPX_Norm.rc_l1_l1(x));
    assertEqual(sqrt(108), SPX_Norm.cr_l1_l2(x));
    assertElementsAlmostEqual(sqrt(126), SPX_Norm.rc_l1_l2(x));
    assertEqual(6, SPX_Norm.cr_l1_linf(x));
    assertEqual(9, SPX_Norm.rc_l1_linf(x));
    assertEqual(3*sqrt(14), SPX_Norm.cr_l2_l1(x));
    assertEqual(sqrt(3) + sqrt(12) + sqrt(27), SPX_Norm.rc_l2_l1(x));
    assertElementsAlmostEqual(sqrt(42), SPX_Norm.cr_l2_l2(x));
    assertElementsAlmostEqual(sqrt(42), SPX_Norm.rc_l2_l2(x));
    assertElementsAlmostEqual(sqrt(14), SPX_Norm.cr_l2_linf(x));
    assertElementsAlmostEqual(sqrt(27), SPX_Norm.rc_l2_linf(x));
    assertEqual(9, SPX_Norm.cr_linf_l1(x));
    assertEqual(6, SPX_Norm.rc_linf_l1(x));
    assertEqual(sqrt(27), SPX_Norm.cr_linf_l2(x));
    assertElementsAlmostEqual(sqrt(14), SPX_Norm.rc_linf_l2(x));
    assertEqual(3, SPX_Norm.cr_linf_linf(x));
    assertEqual(3, SPX_Norm.rc_linf_linf(x));
end
