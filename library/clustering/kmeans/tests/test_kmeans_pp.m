function test_suite = test_kmeans_pp
  initTestSuite;
end


function test_1
    X = [1 2 7 8 20 21 
         1 2 7 8 20 21];
    % Capture current random number generator state
    st = rng;
    % Go to default state
    rng('default'); 
    % Perform testing
    [seeds, labels] = SPX_KMeans.pp_initialize(X, 3);
    assertEqual(seeds, [
        20     8     1
        20     8     1]);
    assertEqual(labels, [3     3     2     2     1     1]);
    % restore previous state
    rng(st);
end

