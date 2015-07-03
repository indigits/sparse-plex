function test_suite = test_spx_vector
  initTestSuite;
end


function test_reverse
    v1 = [1 2 3];
    v2 = [3 2 1];
    assertEqual(v1, SPX_Vec.reverse(v2));
end