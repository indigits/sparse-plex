function tests = test_batch_omp
  tests = functiontests(localfunctions);
end

function [dict, reps, signals, k] = problem_2()
    m = 200;
    n = 1000;
    k = 10;
    s = 500;
    dict = spx.dict.simple.gaussian_dict(m, n);
    gen = spx.data.synthetic.SparseSignalGenerator(n, k, s);
    % create a sparse vector
    reps =  gen.biGaussian();
    signals = dict*reps;
end


function test_batch_omp_1(testCase)
    [A, x, b, k] = problem_2();
    A  = double(A);
    G = A' * A;
    result = spx.fast.batch_omp(A, b, G, [], k, 0);
    cmpare = spx.commons.SparseSignalsComparison(x, result, k);
    cmpare.summarize();
    verifyTrue(testCase, cmpare.all_have_matching_supports(1.0));
end

function test_batch_omp_dtx(testCase)
    [A, x, b, k] = problem_2();
    A  = double(A);
    G = A' * A;
    DtX = A' * b;
    result = spx.fast.batch_omp([], [], G, DtX, k, 0);
    cmpare = spx.commons.SparseSignalsComparison(x, result, k);
    cmpare.summarize();
    verifyTrue(testCase, cmpare.all_have_matching_supports(1.0));
end
