function tests = test_omp
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



function test_naive_omp_1(testCase)
    [A, x, b, k] = problem_1();
    solver = spx.pursuit.single.OrthogonalMatchingPursuit(A, k);
    result = solver.solve(b);
    cmpare = spx.commons.SparseSignalsComparison(x, result.z, k);
    %cmpare.summarize();
    verifyTrue(testCase, cmpare.all_have_matching_supports(1.0));
end


function test_naive_omp_2(testCase)
    [dict, reps, signals, k] = problem_2();
    solver = spx.pursuit.single.OrthogonalMatchingPursuit(dict, k);
    ns = size(signals, 2);
    dd = size(dict, 2);
    recovered = zeros(dd, ns);
    for s=1:ns
        signal = signals(:, s);
        result = solver.solve(signal);
        recovered(:, s) = result.z;
    end
    cmpare = spx.commons.SparseSignalsComparison(reps, recovered, k);
    % cmpare.summarize();
    verifyTrue(testCase, cmpare.all_have_matching_supports(1.0));
end


function test_omp_qr_1(testCase)
    [A, x, b, k] = problem_1();
    solver = spx.pursuit.single.OrthogonalMatchingPursuit(A, k);
    result = solver.solve_qr(b);
    cmpare = spx.commons.SparseSignalsComparison(x, result.z, k);
    %cmpare.summarize();
    verifyTrue(testCase, cmpare.all_have_matching_supports(1.0));
end

function test_omp_qr_2(testCase)
    [dict, reps, signals, k] = problem_2();
    solver = spx.pursuit.single.OrthogonalMatchingPursuit(dict, k);
    ns = size(signals, 2);
    dd = size(dict, 2);
    recovered = zeros(dd, ns);
    for s=1:ns
        signal = signals(:, s);
        result = solver.solve_qr(signal);
        recovered(:, s) = result.z;
    end
    cmpare = spx.commons.SparseSignalsComparison(reps, recovered, k);
    % cmpare.summarize();
    verifyTrue(testCase, cmpare.all_have_matching_supports(1.0));
end
