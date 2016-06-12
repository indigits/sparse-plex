function test_suite = test_l1_recovery
  initTestSuite;
end


function [A, x, b] = problem_1()
    m = 100;
    n = 1000;
    k = 4;
    A = normrnd(0, 1/sqrt(m), m, n);
    % create a sparse vector
    x = zeros(n, 1);
    indices = randperm(n, k);
    x(indices) = normrnd(0, 1, k, 1);
    b = A*x;
end

function [A, X, B] = problem_2()
    m = 100;
    n = 1000;
    k = 4;
    s = 4;
    A = normrnd(0, 1/sqrt(m), m, n);
    % create a sparse vector
    X = zeros(n, s);
    indices = randperm(n, k);
    for i=1:s
        X(indices, i) = normrnd(0, 1, k, 1);
    end
    B = A*X;
end



function test_l1_recovery_lasso
    [A, x, b] = problem_1();
    solver = SPX_L1SparseRecovery(A, b);
    % We require lambda to be 2.5 or more. Otherwise, convergence is bad. 
    % Observations: 
    % for 2.5, we require 18 iterations to converge.
    % for 10, we require 32 iterations to converge.
    lambda = 2.5;
    z = solver.solve_lasso(lambda);
    e = z - x;
    fprintf('\nLasso: x: %f, z: %f, e: %f, ratio: %f\n', norm(x), norm(z), norm(e), norm(e)/norm(x));
    assertVectorsAlmostEqual(x, z);
end

function test_l1_recovery_exact
    [A, x, b] = problem_1();
    solver = SPX_L1SparseRecovery(A, b);
    z = solver.solve_l1_exact();
    e = z - x;
    fprintf('\nExact: x: %f, z: %f, e: %f, ratio: %f\n', norm(x), norm(z), norm(e), norm(e)/norm(x));
    assertVectorsAlmostEqual(x, z);
end

function test_l1_recovery_noise
    [A, x, b] = problem_1();
    solver = SPX_L1SparseRecovery(A, b);
    z = solver.solve_l1_noise();
    e = z - x;
    fprintf('\n Noisy: x: %f, z: %f, e: %f, ratio: %f\n', norm(x), norm(z), norm(e), norm(e)/norm(x));
    assertVectorsAlmostEqual(x, z, 'relative', 0.002);
end

function test_l1_recovery_lasso_multi
    [A, X, B] = problem_2();
    solver = SPX_L1SparseRecovery(A, B);
    % We require lambda to be 2.5 or more. Otherwise, convergence is bad. 
    % Observations: 
    % for 2.5, we require 18 iterations to converge.
    % for 10, we require 32 iterations to converge.
    lambda = 2.5;
    Z = solver.solve_lasso(lambda);
    E = Z - X;
    s  = size(X, 2);
    for i=1:s
        x = X(:, i);
        z = Z(:, i);
        e = E(:, i);
        fprintf('\n Lasso multi: x: %f, z: %f, e: %f, ratio: %f\n', norm(x), norm(z), norm(e), norm(e)/norm(x));
        assertVectorsAlmostEqual(x, z);
    end
end


function test_l1_recovery_exact_multi
    [A, X, B] = problem_2();
    solver = SPX_L1SparseRecovery(A, B);
    Z = solver.solve_l1_exact();
    E = Z - X;
    s  = size(X, 2);
    for i=1:s
        x = X(:, i);
        z = Z(:, i);
        e = E(:, i);
        fprintf('\nExact multi: x: %f, z: %f, e: %f, ratio: %f\n', norm(x), norm(z), norm(e), norm(e)/norm(x));
        assertVectorsAlmostEqual(x, z);
    end
end

function test_l1_recovery_noise_multi
    [A, X, B] = problem_2();
    solver = SPX_L1SparseRecovery(A, B);
    Z = solver.solve_l1_noise();
    E = Z - X;
    s  = size(X, 2);
    for i=1:s
        x = X(:, i);
        z = Z(:, i);
        e = E(:, i);
        fprintf('\n Noisy multi: x: %f, z: %f, e: %f, ratio: %f\n', norm(x), norm(z), norm(e), norm(e)/norm(x));
        assertVectorsAlmostEqual(x, z, 'relative', 0.003);
    end
end

