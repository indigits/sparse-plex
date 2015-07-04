function test_suite = test_statistics
  initTestSuite;
end


function test_mean
    x = 1:100;
    xm = SPX_Statistics.compute_statistic_per_vector(x, 1, @mean);
    assertEqual (xm', x);
end
