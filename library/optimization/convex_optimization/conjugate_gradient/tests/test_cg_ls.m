function test_suite = test_cg_ls
    clear all;
    initTestSuite;
end


function test_1
    A = [
    1 -1
    1 1
    2 1
    ];

    B = [
    2
    4 
    8
    ];
    solver = SPX_CGLeastSquare(A, B);
    x = solver.solve();
    %solver.printResults();
    assertTrue(solver.hasConverged());
end

function test_2
    m = 10;
    n = 4;
    s = 100;
    %rng('default');
    A = randn(m, n);
    X = randn(n, s);
    B = A * X;
    solver = SPX_CGLeastSquare(A, B);
    XX = solver.solve();
    % solver.printResults();
    % disp(X);
    % disp(XX);
    assertTrue(solver.hasConverged());
end

function test_3
    m = 1000;
    n = 40;
    s = 10;
    %rng('default');
    A = randn(m, n);
    X = randn(n, s);
    B = A * X;
    solver = SPX_CGLeastSquare(A, B);
    XX = solver.solve();
    % solver.printResults();
    % disp(X);
    % disp(XX);
    assertTrue(solver.hasConverged());
end



