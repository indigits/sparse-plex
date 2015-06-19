function test_suite = test_omp
  initTestSuite;
end


function [A, x, b, k] = problem_1()
    m = 100;
    n = 1000;
    k = 4;
    A = SPX_BasicDictionaryCreator.Gaussian(m, n);
    gen = SPX_SparseSignalGenerator(n, k);
    % create a sparse vector
    x =  gen.biGaussian();
    b = A*x;
end

function [dict, reps, signals, k] = problem_2()
    m = 200;
    n = 1000;
    k = 10;
    s = 500;
    dict = SPX_BasicDictionaryCreator.Gaussian(m, n);
    gen = SPX_SparseSignalGenerator(n, k, s);
    % create a sparse vector
    reps =  gen.biGaussian();
    signals = dict*reps;
end



function test_cosamp_1
    [A, x, b, k] = problem_1();
    solver = SPX_CoSaMP(A, k);
    result = solver.solve(b);
    cmpare = SPX_SparseSignalsComparison(x, result.z, k);
    %cmpare.summarize();
    assertTrue(cmpare.has_matching_supports(1.0));
end


function test_cosamp_2
    [dict, reps, signals, k] = problem_2();
    solver = SPX_CoSaMP(dict, k);
    ns = size(signals, 2);
    dd = size(dict, 2);
    recovered = zeros(dd, ns);
    for s=1:ns
        signal = signals(:, s);
        result = solver.solve(signal);
        recovered(:, s) = result.z;
    end
    cmpare = SPX_SparseSignalsComparison(reps, recovered, k);
    % cmpare.summarize();
    assertTrue(cmpare.has_matching_supports(1.0));
end


