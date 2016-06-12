function tests = test_basic_noise
  tests = functiontests(localfunctions);
end

function test1(testCase)
    N = 100;
    S = 100;
    gen = spx.data.noise.Basic(N, S);
    sigma = 1;
    X = gen.gaussian(sigma);
    variance = sum(sum(X.^2)) / (N * S);
    verifyEqual(testCase, sigma, variance, 'RelTol', .1);
end
