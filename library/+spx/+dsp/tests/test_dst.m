function test_suite = test_dst
  initTestSuite;
end

function test_dst_1

    x = cos((1:15) * .1);
    alpha = SPX_DST.forward_1(x);
    y = SPX_DST.inverse_1(alpha);
    assertVectorsAlmostEqual(x, y);
end


function test_dst_2
    n = 256;
    for i=randperm(n, 40)
        x = SPX_Vec.unit_vector(n, i);
        alpha = SPX_DST.forward_2(x);
        assertElementsAlmostEqual(norm(x), norm(alpha));
        y = SPX_DST.inverse_2(alpha);
        assertElementsAlmostEqual(norm(y), norm(alpha));
        assertVectorsAlmostEqual(x, y);
        alpha = SPX_DST.forward_3(x);
        assertElementsAlmostEqual(norm(x), norm(alpha));
        y = SPX_DST.inverse_3(alpha);
        assertElementsAlmostEqual(norm(y), norm(alpha));
        assertVectorsAlmostEqual(x, y);
    end
end
