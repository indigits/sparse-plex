function test_suite = test_dst
  initTestSuite;
end

function test_dst_1

    x = cos((1:15) * .1);
    alpha = SPX_DST.forward_1(x);
    y = SPX_DST.inverse_1(alpha);
    assertVectorsAlmostEqual(x, y);
end

