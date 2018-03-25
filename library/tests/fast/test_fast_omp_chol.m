function tests = test_fast_omp_chol
  tests = functiontests(localfunctions);
end


function [A, x, b, k] = problem_1()
    m = 100;
    n = 1000;
    k = 4;
    A = spx.dict.simple.gaussian_dict(m, n);
    gen = spx.data.synthetic.SparseSignalGenerator(n, k);
    % create a sparse vector
    x =  gen.biGaussian();
    b = A*x;
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





function test_omp_chol_1(testCase)
    [A, x, b, k] = problem_1();
    A  = double(A);
    result = spx.fast.omp(A, b, k, 1e-12);
    cmpare = spx.commons.SparseSignalsComparison(x, result, k);
    cmpare.summarize();
    verifyTrue(testCase, cmpare.all_have_matching_supports(1.0));
end


function test_omp_chol_2(testCase)
    [A, x, b, k] = problem_2();
    A  = double(A);
    result = spx.fast.omp(A, b, k, 1e-12);
    cmpare = spx.commons.SparseSignalsComparison(x, result, k);
    cmpare.summarize();
    verifyTrue(testCase, cmpare.all_have_matching_supports(1.0));
end
