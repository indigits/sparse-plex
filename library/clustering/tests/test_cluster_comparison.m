function test_suite = test_cluster_comparison
  initTestSuite;
end

function test_complete_match_1
    a  = [1 1 1 2 2 2];
    b = [2 2 2 1 1 1];
    comparer = SPX_ClusterComparison(a, b);
    result = comparer.fMeasure();
    assertElementsAlmostEqual(result.fMeasure, 1.0);
    assertElementsAlmostEqual(result.precision, 1.0);
    assertElementsAlmostEqual(result.recall, 1.0);
    %SPX_ClusterComparison.printF1MeasureResult(result);
end

function test_one_mismatch_1
    a  = [1 1 1 2 2 2];
    b = [2 2 1 1 1 1];
    comparer = SPX_ClusterComparison(a, b);
    [randIndex, breakup] = comparer.randIndex();
    assertEqual(breakup, [4, 6, 2, 3]);
    assertElementsAlmostEqual(randIndex, 10/15);
    result = comparer.fMeasure();
    tolerance = 0.0001;
    assertElementsAlmostEqual(result.fMeasure, 0.8286, 'relative', tolerance);
    assertElementsAlmostEqual(result.precision, 0.8333, 'relative', tolerance);
    assertElementsAlmostEqual(result.recall, 0.8333, 'relative', tolerance);
    %SPX_ClusterComparison.printF1MeasureResult(result);
end
