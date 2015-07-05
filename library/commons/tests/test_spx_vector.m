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
