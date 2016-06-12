function tests = test_spx_norms
  tests = functiontests(localfunctions);
end


function test_lp_norms(testCase)
    import spx.commons.norm;
    x = [1 1 1  
         2 2 2
        3 3 3];
    verifyEqual(testCase, [6 6 6], norm.norms_l1_cw(x));
    verifyEqual(testCase, [3 6 9]', norm.norms_l1_rw(x));
    verifyEqual(testCase, sqrt([14 14 14]), norm.norms_l2_cw(x));
    verifyEqual(testCase, sqrt([3 12 27]'), norm.norms_l2_rw(x));
    verifyEqual(testCase, [3 3 3], norm.norms_linf_cw(x));
    verifyEqual(testCase, [1 2 3]', norm.norms_linf_rw(x));
    verifyEqual(testCase, 18, norm.cr_l1_l1(x));
    verifyEqual(testCase, 18, norm.rc_l1_l1(x));
    verifyEqual(testCase, sqrt(108), norm.cr_l1_l2(x));
    verifyEqual(testCase, sqrt(126), norm.rc_l1_l2(x), 'AbsTol', 1e-6);
    verifyEqual(testCase, 6, norm.cr_l1_linf(x));
    verifyEqual(testCase, 9, norm.rc_l1_linf(x));
    verifyEqual(testCase, 3*sqrt(14), norm.cr_l2_l1(x));
    verifyEqual(testCase, sqrt(3) + sqrt(12) + sqrt(27), norm.rc_l2_l1(x));
    verifyEqual(testCase, sqrt(42), norm.cr_l2_l2(x), 'AbsTol', 1e-6);
    verifyEqual(testCase, sqrt(42), norm.rc_l2_l2(x), 'AbsTol', 1e-6);
    verifyEqual(testCase, sqrt(14), norm.cr_l2_linf(x));
    verifyEqual(testCase, sqrt(27), norm.rc_l2_linf(x));
    verifyEqual(testCase, 9, norm.cr_linf_l1(x));
    verifyEqual(testCase, 6, norm.rc_linf_l1(x));
    verifyEqual(testCase, sqrt(27), norm.cr_linf_l2(x), 'AbsTol', 1e-6);
    verifyEqual(testCase, sqrt(14), norm.rc_linf_l2(x), 'AbsTol', 1e-6);
    verifyEqual(testCase, 3, norm.cr_linf_linf(x));
    verifyEqual(testCase, 3, norm.rc_linf_linf(x));
end
