function tests = test_cluster_comparison
  tests = functiontests(localfunctions);
end

function test_complete_match_1(testCase)
    a  = [1 1 1 2 2 2];
    b = [2 2 2 1 1 1];
    comparer = spx.cluster.ClusterComparison(a, b);
    result = comparer.fMeasure();
    verifyEqual(testCase, result.fMeasure, 1.0);
    verifyEqual(testCase, result.precision, 1.0);
    verifyEqual(testCase, result.recall, 1.0);
    %spx.cluster.ClusterComparison.printF1MeasureResult(result);
end

function test_one_mismatch_1(testCase)
    a  = [1 1 1 2 2 2];
    b = [2 2 1 1 1 1];
    comparer = spx.cluster.ClusterComparison(a, b);
    [randIndex, breakup] = comparer.randIndex();
    assertEqual(testCase, breakup, [4, 6, 2, 3]);
    verifyEqual(testCase, randIndex, 10/15);
    result = comparer.fMeasure();
    tolerance = 0.0001;
    verifyEqual(testCase, result.fMeasure, 0.8286, 'RelTol', tolerance);
    verifyEqual(testCase, result.precision, 0.8333, 'RelTol', tolerance);
    verifyEqual(testCase, result.recall, 0.8333, 'RelTol', tolerance);
    %spx.cluster.ClusterComparison.printF1MeasureResult(result);
end
