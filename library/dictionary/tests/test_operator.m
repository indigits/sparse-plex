function test_suite = test_operator
    clear all;
    initTestSuite;
end

function test_1
    b = [ 1 2 3; 3 4 3];
    bb = SPX_MatrixOperator(b);
    [m, n] = size(bb);
    assertEqual([m, n], size(b));
    bbb = double(bb);
    assertEqual(bbb, b);
    v = [1 2 3]';
    assertEqual(b*v, bb*v);
    v = [1 2]';
    assertEqual(b'*v, bb'*v);
    assertEqual(b', bb');
    assertEqual(b.', bb.');
    b2 = bb.columns_operator([1 2]);
    assertEqual(double(b2), b(:, [1 2]));
end
