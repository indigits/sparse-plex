function test_suite = test_statistics
  initTestSuite;
end


function test_autocorr
    x = [1 2 3];
    r1 = xcorr(x);
    r2 = SPX_Statistics.auto_correlation(x);
    assertElementsAlmostEqual(r1, r2);   
    for i=1:100
        x = randn(1000, 1);
        r1 = xcorr(x);
        r2 = SPX_Statistics.auto_correlation(x);
        % fprintf('.');
        assertElementsAlmostEqual(r1, r2);   
    end
end