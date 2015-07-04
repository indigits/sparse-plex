function test_suite = test_ssp
  initTestSuite;
end


function test_autocorr
    x = [1 2 3];
    r1 = xcorr(x);
    r2 = SPX_SSP.auto_correlation(x);
    assertElementsAlmostEqual(r1, r2);   
    for i=1:100
        x = randn(1000, 1);
        r1 = xcorr(x);
        r2 = SPX_SSP.auto_correlation(x);
        % fprintf('.');
        assertElementsAlmostEqual(r1, r2);   
    end
end


function test_xcorr
    x = [1 2 3];
    y = [ 4 3 1 2];
    r1 = xcorr(x, y);
    r2 = SPX_SSP.cross_correlation(x, y);
    nr  = length(r2);
    assertElementsAlmostEqual(r1(1:nr), r2);   
    for i=1:100
        x = randn(1000, 1);
        y = randn(1000, 1);
        r1 = xcorr(x, y);
        r2 = SPX_SSP.cross_correlation(x, y);
        nr  = length(r2);
        % fprintf('.');
        assertElementsAlmostEqual(r1(1:nr), r2);   
    end
end