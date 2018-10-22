function tests = test_spx_vector
  tests = functiontests(localfunctions);
end


function test_reverse(testCase)
    v1 = [1 2 3];
    v2 = [3 2 1];
    verifyEqual(testCase, v1, spx.vector.reverse(v2));
end

function test_reshape_as_row(testCase)
    x = [1 2 3];
    y = spx.vector.reshape_as_row_vec(x);
    verifyEqual(testCase, x, y);
    x = x';
    y = spx.vector.reshape_as_row_vec(x);
    verifyEqual(testCase, x', y);
end

function test_reshape_as_col(testCase)
    x = [1 2 3];
    y = spx.vector.reshape_as_col_vec(x);
    verifyEqual(testCase, x', y);
    x = x';
    y = spx.vector.reshape_as_col_vec(x);
    verifyEqual(testCase, x, y);
end


function test_reshape_as_proto(testCase)
    x = [1 2 3];
    p = [1 2 3 4]';
    y = spx.vector.reshape_as_prototype(x, p);
    verifyEqual(testCase, x', y);
    p = p';
    y = spx.vector.reshape_as_prototype(x, p);
    verifyEqual(testCase, x, y);
    x = x';
    y = spx.vector.reshape_as_prototype(x, p);
    verifyEqual(testCase, x', y);
    x = x';
    y = spx.vector.reshape_as_prototype(x, p);
    verifyEqual(testCase, x, y);
end


function test_shift_r(testCase)
    x = [1 2 3];
    y = spx.vector.shift_r(x);
    verifyEqual(testCase, y, [0 1 2]);
    x = x';
    y = spx.vector.shift_r(x);
    verifyEqual(testCase, y, [0 1 2]');
end

function test_shift_rc(testCase)
    x = [1 2 3];
    y = spx.vector.shift_rc(x);
    verifyEqual(testCase, y, [3 1 2]);
    x = x';
    y = spx.vector.shift_rc(x);
    verifyEqual(testCase, y, [3 1 2]');
end

function test_shift_l(testCase)
    x = [1 2 3];
    y = spx.vector.shift_l(x);
    verifyEqual(testCase, y, [2 3 0]);
    x = x';
    y = spx.vector.shift_l(x);
    verifyEqual(testCase, y, [2 3 0]');
end

function test_shift_lc(testCase)
    x = [1 2 3];
    y = spx.vector.shift_lc(x);
    verifyEqual(testCase, y, [2 3 1]);
    x = x';
    y = spx.vector.shift_lc(x);
    verifyEqual(testCase, y, [2 3 1]');
end

function test_shift_rn(testCase)
    x = [1 2 3 4];
    y = spx.vector.shift_rn(x, 2);
    verifyEqual(testCase, y, [0 0 1 2]);
    x = x';
    y = spx.vector.shift_rn(x, 2);
    verifyEqual(testCase, y, [0 0 1 2]');
end

function test_shift_rcn(testCase)
    x = [1 2 3 4];
    y = spx.vector.shift_rcn(x, 2);
    verifyEqual(testCase, y, [3 4 1 2]);
    x = x';
    y = spx.vector.shift_rcn(x, 2);
    verifyEqual(testCase, y, [3 4 1 2]');
end

function test_shift_ln(testCase)
    x = [1 2 3 4];
    y = spx.vector.shift_ln(x, 2);
    verifyEqual(testCase, y, [3 4 0 0]);
    x = x';
    y = spx.vector.shift_ln(x, 2);
    verifyEqual(testCase, y, [3 4 0 0]');
end

function test_shift_lcn(testCase)
    x = [1 2 3 4];
    y = spx.vector.shift_lcn(x, 2);
    verifyEqual(testCase, y, [3 4 1 2]);
    x = x';
    y = spx.vector.shift_lcn(x, 2);
    verifyEqual(testCase, y, [3 4 1 2]');
end

function test_repeat_at_end(testCase)
    x  = 1:4;
    y = spx.vector.repeat_vector_at_end(x, 2);
    verifyEqual(testCase, y, [1:4 1:2]);
    y = spx.vector.repeat_vector_at_end(x, 4);
    verifyEqual(testCase, y, [1:4 1:4]);
    y = spx.vector.repeat_vector_at_end(x, 6);
    verifyEqual(testCase, y, [1:4 1:4 1:2]);
end

function test_repeat_at_start(testCase)
    x  = 1:4;
    y = spx.vector.repeat_vector_at_start(x, 2);
    verifyEqual(testCase, y, [3:4 1:4]);
    y = spx.vector.repeat_vector_at_start(x, 4);
    verifyEqual(testCase, y, [1:4 1:4]);
    y = spx.vector.repeat_vector_at_start(x, 6);
    verifyEqual(testCase, y, [3:4 1:4 1:4]);
end

