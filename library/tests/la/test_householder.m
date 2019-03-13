function tests = test_householder
  tests = functiontests(localfunctions);
end

function [v, beta, y] = verify_house(x, testCase)
    [v , beta] = spx.la.house.gen(x);
    y = spx.la.house.premul(x, v, beta);
    verifyEqual(testCase, norm(y), norm(x), 'AbsTol', 1e-12);
    verifyEqual(testCase, y(2:3), zeros(2,1), 'AbsTol', 1e-12);
    y = spx.la.house.postmul(x', v, beta)';
    verifyEqual(testCase, norm(y), norm(x), 'AbsTol', 1e-12);
    verifyEqual(testCase, y(2:3), zeros(2,1), 'AbsTol', 1e-12);
end

function test_1(testCase)
    x = [ 1 0  0]';
    [v, beta, y] = verify_house(x, testCase);
    verifyEqual(testCase, v, x);
    verifyEqual(testCase, beta, 0);
end

function test_2(testCase)
    x = [1 1 0]';
    verify_house(x, testCase);
end

function test_3(testCase)
    x = [-1 1 0]';
    verify_house(x, testCase);
end


function test_4(testCase)
    x = [0 1 0]';
    verify_house(x, testCase);
end

function test_5(testCase)
    x = [0 -1 1 -1 0 0 0 0]';
    verify_house(x, testCase);
end
