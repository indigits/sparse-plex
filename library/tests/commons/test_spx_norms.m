function tests = test_spx_norms
  tests = functiontests(localfunctions);
end


function test_lp_norms(testCase)
    x = [1 1 1  
         2 2 2
        3 3 3];
    verifyEqual(testCase, [6 6 6], spx.norm.norms_l1_cw(x));
    verifyEqual(testCase, [3 6 9]', spx.norm.norms_l1_rw(x));
    verifyEqual(testCase, sqrt([14 14 14]), spx.norm.norms_l2_cw(x));
    verifyEqual(testCase, sqrt([3 12 27]'), spx.norm.norms_l2_rw(x));
    verifyEqual(testCase, [3 3 3], spx.norm.norms_linf_cw(x));
    verifyEqual(testCase, [1 2 3]', spx.norm.norms_linf_rw(x));
    verifyEqual(testCase, 18, spx.norm.cr_l1_l1(x));
    verifyEqual(testCase, 18, spx.norm.rc_l1_l1(x));
    verifyEqual(testCase, sqrt(108), spx.norm.cr_l1_l2(x));
    verifyEqual(testCase, sqrt(126), spx.norm.rc_l1_l2(x), 'AbsTol', 1e-6);
    verifyEqual(testCase, 6, spx.norm.cr_l1_linf(x));
    verifyEqual(testCase, 9, spx.norm.rc_l1_linf(x));
    verifyEqual(testCase, 3*sqrt(14),spx.norm.cr_l2_l1(x));
    verifyEqual(testCase, sqrt(3) + sqrt(12) + sqrt(27), spx.norm.rc_l2_l1(x));
    verifyEqual(testCase, sqrt(42), spx.norm.cr_l2_l2(x), 'AbsTol', 1e-6);
    verifyEqual(testCase, sqrt(42), spx.norm.rc_l2_l2(x), 'AbsTol', 1e-6);
    verifyEqual(testCase, sqrt(14), spx.norm.cr_l2_linf(x));
    verifyEqual(testCase, sqrt(27), spx.norm.rc_l2_linf(x));
    verifyEqual(testCase, 9, spx.norm.cr_linf_l1(x));
    verifyEqual(testCase, 6, spx.norm.rc_linf_l1(x));
    verifyEqual(testCase, sqrt(27), spx.norm.cr_linf_l2(x), 'AbsTol', 1e-6);
    verifyEqual(testCase, sqrt(14), spx.norm.rc_linf_l2(x), 'AbsTol', 1e-6);
    verifyEqual(testCase, 3, spx.norm.cr_linf_linf(x));
    verifyEqual(testCase, 3, spx.norm.rc_linf_linf(x));
end
