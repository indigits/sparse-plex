function tests = test_operator
  tests = functiontests(localfunctions);
end

function test_1(testCase)
    b = [ 1 2 3; 3 4 3];
    bb = spx.dict.MatrixOperator(b);
    [m, n] = size(bb);
    verifyEqual(testCase, [m, n], size(b));
    bbb = double(bb);
    verifyEqual(testCase, bbb, b);
    v = [1 2 3]';
    verifyEqual(testCase, b*v, bb*v);
    v = [1 2]';
    verifyEqual(testCase, b'*v, bb'*v);
    c = bb';
    verifyEqual(testCase, b', c.A);
    c = bb.';
    verifyEqual(testCase, b.', c.A);
    b2 = bb.columns_operator([1 2]);
    verifyEqual(testCase, double(b2), b(:, [1 2]));
end
