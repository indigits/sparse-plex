function tests = test_kmeans_pp
  tests = functiontests(localfunctions);
end


function test_1(testCase)
    X = [1 2 7 8 20 21 
         1 2 7 8 20 21];
    % Capture current random number generator state
    st = rng;
    % Go to default state
    rng('default'); 
    % Perform testing
    [seeds, labels] = spx.cluster.kmeans.pp_initialize(X, 3);
    verifyEqual(testCase, seeds, [
        20     8     1
        20     8     1]);
    verifyEqual(testCase, labels, [3     3     2     2     1     1]);
    % restore previous state
    rng(st);
end

