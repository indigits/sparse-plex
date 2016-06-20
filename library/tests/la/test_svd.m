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

function test_vidal_rank(testCase)
    s = [ 1 1 1 1  0  0];
    for kappa=0:.01:.24
        r = spx.la.svd.vidal_rank(s, kappa);
        verifyEqual(testCase, r, 4);
    end

    s = [ 1 .9 .8 .7  .3  .2 .1];
    for kappa=0.02:0.01:.16
        r = spx.la.svd.vidal_rank(s, kappa);
        % fprintf('%f, %d\n', kappa, r);
        verifyEqual(testCase, r, 4);
    end
    for kappa=0.17:0.01:2
        r = spx.la.svd.vidal_rank(s, kappa);
        % fprintf('%f, %d\n', kappa, r);
        verifyNotEqual(testCase, r, 4);
    end

end
