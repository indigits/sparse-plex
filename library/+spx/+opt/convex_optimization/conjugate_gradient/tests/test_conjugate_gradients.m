function test_suite = test_conjugate_gradients
    clear all;
    initTestSuite;
end


function test_1
    A = [3 2; 2 6];
    X = [2 1 0 4; -2 2 0 4];
    B = A * X;
    solver = SPX_ConjugateDescent(A, B);
    x = solver.solve();
    %solver.printResults();
    verifyTrue(testCase, solver.hasConverged());
end

function test_2
    A  = [
    2 -1 0; 
    -1 2 -1;
    0 -1 2];
    X = randi(10, 3,3);
    B = A * X;
    solver = SPX_ConjugateDescent(A, B);
    solver.MaxIterations = 50; 
    x = solver.solve();
    verifyTrue(testCase, solver.hasConverged());
end


