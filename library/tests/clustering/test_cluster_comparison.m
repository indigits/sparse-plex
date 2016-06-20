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


function test_cluster_error(testCase)
    true_labels = [ 1 1 1 1 2 2 2 2];
    result = spx.cluster.clustering_error(true_labels, true_labels, 2);
    verifyEqual(testCase, result.error, 0);
    verifyEqual(testCase, result.mapping, [1 2]);
    estimated_labels = [2 2 2 2 1 1 1 1];
    result = spx.cluster.clustering_error(estimated_labels, true_labels, 2);
    verifyEqual(testCase, result.error, 0);
    verifyEqual(testCase, result.mapping, [2 1]);
    estimated_labels = [2 2 2 1 1 1 1 1];
    result = spx.cluster.clustering_error(estimated_labels, true_labels, 2);
    verifyEqual(testCase, result.error, 1/8);
    verifyEqual(testCase, result.mapping, [2 1]);

    true_labels  = randi([1, 5], 1, 100);
    true_mapping = [4 5 3 2 1];
    estimated_labels = true_mapping(true_labels);
    result = spx.cluster.clustering_error(estimated_labels, true_labels, 5);
    verifyEqual(testCase, result.error, 0);
    verifyEqual(testCase, result.mapping, true_mapping);

    % change a few of them
    indices = randperm(100, 10);
    % change their indices by 1->2->3->4->5->1.
    estimated_labels(indices) = mod(estimated_labels(indices) + 1, 5) + 1;
    % calculate the error
    result = spx.cluster.clustering_error(estimated_labels, true_labels, 5);
    verifyEqual(testCase, result.error, 0.1);
    verifyEqual(testCase, result.mapping, true_mapping);

end

