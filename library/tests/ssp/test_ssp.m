function tests = test_ssp
  tests = functiontests(localfunctions);
end


function test_autocorr(testCase)
    x = [1 2 3];
    r1 = xcorr(x);
    r2 = spx.ssp.auto_correlation(x);
    verifyEqual(testCase, r1, r2, 'AbsTol', 1e-12);   
    for i=1:100
        x = randn(1000, 1);
        r1 = xcorr(x);
        r2 = spx.ssp.auto_correlation(x);
        % fprintf('.');
        verifyEqual(testCase, r1, r2, 'AbsTol', 1e-12);   
    end
end


function test_xcorr(testCase)
    x = [1 2 3];
    y = [ 4 3 1 2];
    r1 = xcorr(x, y);
    r2 = spx.ssp.cross_correlation(x, y);
    nr  = length(r2);
    verifyEqual(testCase, r1(1:nr), r2, 'AbsTol', 1e-12);   
    for i=1:100
        x = randn(1000, 1);
        y = randn(1000, 1);
        r1 = xcorr(x, y);
        r2 = spx.ssp.cross_correlation(x, y);
        nr  = length(r2);
        % fprintf('.');
        verifyEqual(testCase, r1(1:nr), r2, 'AbsTol', 1e-12);   
    end
end