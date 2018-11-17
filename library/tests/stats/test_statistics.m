function tests = test_statistics
  tests = functiontests(localfunctions);
end


function test_mean(testCase)
    x = 1:100;
    xm = spx.stats.compute_statistic_per_vector(x, 1, @mean);
    verifyEqual(testCase, xm', x);
end
