function tests = test_svd
  tests = functiontests(localfunctions);
end


function test_mahdi_rank(testCase)
    s = [ 1 1 1 1  0  0];
    [r, g] = spx.la.svd.mahdi_rank(s);
    verifyEqual(testCase, r, 4);
    verifyEqual(testCase, g, 1);

    s = [ 1 .9 .8 .7  .3  .2 .1];
    [r, g] = spx.la.svd.mahdi_rank(s);
    verifyEqual(testCase, r, 4);
    verifyEqual(testCase, g, .4, 'AbsTol', 1e-12);

end