function test_suite = test_spx_vector
  initTestSuite;
end


function test_reverse
    v1 = [1 2 3];
    v2 = [3 2 1];
    assertEqual(v1, SPX_Vec.reverse(v2));
end

function test_reshape_as_row
    x = [1 2 3];
    y = SPX_Vec.reshape_as_row_vec(x);
    assertEqual(x, y);
    x = x';
    y = SPX_Vec.reshape_as_row_vec(x);
    assertEqual(x', y);
end

function test_reshape_as_col
    x = [1 2 3];
    y = SPX_Vec.reshape_as_col_vec(x);
    assertEqual(x', y);
    x = x';
    y = SPX_Vec.reshape_as_col_vec(x);
    assertEqual(x, y);
end


function test_reshape_as_proto
    x = [1 2 3];
    p = [1 2 3 4]';
    y = SPX_Vec.reshape_as_prototype(x, p);
    assertEqual(x', y);
    p = p';
    y = SPX_Vec.reshape_as_prototype(x, p);
    assertEqual(x, y);
    x = x';
    y = SPX_Vec.reshape_as_prototype(x, p);
    assertEqual(x', y);
    x = x';
    y = SPX_Vec.reshape_as_prototype(x, p);
    assertEqual(x, y);
end


function test_shift_r
    x = [1 2 3];
    y = SPX_Vec.shift_r(x);
    assertEqual(y, [0 1 2]);
    x = x';
    y = SPX_Vec.shift_r(x);
    assertEqual(y, [0 1 2]');
end

function test_shift_rc
    x = [1 2 3];
    y = SPX_Vec.shift_rc(x);
    assertEqual(y, [3 1 2]);
    x = x';
    y = SPX_Vec.shift_rc(x);
    assertEqual(y, [3 1 2]');
end

function test_shift_l
    x = [1 2 3];
    y = SPX_Vec.shift_l(x);
    assertEqual(y, [2 3 0]);
    x = x';
    y = SPX_Vec.shift_l(x);
    assertEqual(y, [2 3 0]');
end

function test_shift_lc
    x = [1 2 3];
    y = SPX_Vec.shift_lc(x);
    assertEqual(y, [2 3 1]);
    x = x';
    y = SPX_Vec.shift_lc(x);
    assertEqual(y, [2 3 1]');
end

function test_shift_rn
    x = [1 2 3 4];
    y = SPX_Vec.shift_rn(x, 2);
    assertEqual(y, [0 0 1 2]);
    x = x';
    y = SPX_Vec.shift_rn(x, 2);
    assertEqual(y, [0 0 1 2]');
end

function test_shift_rcn
    x = [1 2 3 4];
    y = SPX_Vec.shift_rcn(x, 2);
    assertEqual(y, [3 4 1 2]);
    x = x';
    y = SPX_Vec.shift_rcn(x, 2);
    assertEqual(y, [3 4 1 2]');
end

function test_shift_ln
    x = [1 2 3 4];
    y = SPX_Vec.shift_ln(x, 2);
    assertEqual(y, [3 4 0 0]);
    x = x';
    y = SPX_Vec.shift_ln(x, 2);
    assertEqual(y, [3 4 0 0]');
end

function test_shift_lcn
    x = [1 2 3 4];
    y = SPX_Vec.shift_lcn(x, 2);
    assertEqual(y, [3 4 1 2]);
    x = x';
    y = SPX_Vec.shift_lcn(x, 2);
    assertEqual(y, [3 4 1 2]');
end

function test_repeat_at_end
    x  = 1:4;
    y = SPX_Vec.repeat_vector_at_end(x, 2);
    assertEqual(y, [1:4 1:2]);
    y = SPX_Vec.repeat_vector_at_end(x, 4);
    assertEqual(y, [1:4 1:4]);
    y = SPX_Vec.repeat_vector_at_end(x, 6);
    assertEqual(y, [1:4 1:4 1:2]);
end

function test_repeat_at_start
    x  = 1:4;
    y = SPX_Vec.repeat_vector_at_start(x, 2);
    assertEqual(y, [3:4 1:4]);
    y = SPX_Vec.repeat_vector_at_start(x, 4);
    assertEqual(y, [1:4 1:4]);
    y = SPX_Vec.repeat_vector_at_start(x, 6);
    assertEqual(y, [3:4 1:4 1:4]);
end

