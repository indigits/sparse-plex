function test_suite = test_prob
  initTestSuite;
end

function test_is_pmf
    x = [.1 .4 .3 .2];
    verifyTrue(testCase, SPX_Prob.is_pmf(x));
    x = [-.1 .6 .3 .2];
    assertFalse(SPX_Prob.is_pmf(x));
end