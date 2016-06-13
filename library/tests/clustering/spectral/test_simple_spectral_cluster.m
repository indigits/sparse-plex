function tests = test_spectral_cluster
  tests = functiontests(localfunctions);
end

function problem = problem1()
    problem.W = [ones(4) zeros(4); zeros(4) ones(4)];
    problem.num_clusters = 2;
    problem.labels = [1 1 1 1 2 2 2 2];
end

function verify_problem(testCase, problem, result)
    verifyEqual(testCase, result.num_clusters, problem.num_clusters);
    verifyEqual(testCase, result.singular_values, problem.singular_values, 'AbsTol', 1e-12);
    comparer = spx.cluster.ClusterComparison(problem.labels, result.labels);
    result = comparer.fMeasure();
    verifyEqual(testCase, result.fMeasure, 1.0);
end

function test_unnormalized(testCase)
    problem = problem1();
    problem.singular_values = [4 4 4 4 4 4 0 0]';
    result = spx.cluster.spectral.simple.unnormalized(problem.W);
    verify_problem(testCase, problem, result);
end

function test_random_walk(testCase)
    problem = problem1();
    problem.singular_values = [1 1 1 1 1 1 0 0]';
    result = spx.cluster.spectral.simple.normalized_random_walk(problem.W);
    verify_problem(testCase, problem, result);
end

function test_symmetric(testCase)
    problem = problem1();
    problem.singular_values = [1 1 1 1 1 1 0 0]';
    result = spx.cluster.spectral.simple.normalized_symmetric(problem.W);
    verify_problem(testCase, problem, result);
end
