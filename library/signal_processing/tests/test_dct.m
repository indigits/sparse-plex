function test_suite = test_dct
  initTestSuite;
end

function test_forward()
    n = 256;
    for i=randperm(n, 40)
        x = SPX_Vec.unit_vector(n, i);
        alpha = SPX_DCT.forward_2(x);
        y = SPX_DCT.inverse_2(alpha);
        assertVectorsAlmostEqual(x, y);
        alpha = SPX_DCT.forward_3(x);
        y = SPX_DCT.inverse_3(alpha);
        assertVectorsAlmostEqual(x, y);
    end
    x  = cos(1:n);
    alpha1 = SPX_DCT.forward_2(x);
    alpha2 = dct(x);
    assertVectorsAlmostEqual(alpha1, alpha2);
    y1 = SPX_DCT.inverse_2(alpha1);
    y2 = idct(alpha2); 
    assertVectorsAlmostEqual(y1, y2);
end


function test_dct_basis_strang
    n = 256;
    d1 = SPX_DCT.basis_strang(n, 2);
    d2 = dctmtx(n)';
    for i=1:n
        v1 = d1(:, i);
        v2 = d2(:, i);
        if (v1(1) > 0)  & (v2(1) > 0)
            assertVectorsAlmostEqual(v1, v2);
        else
            assertVectorsAlmostEqual(v1, -v2);
        end
    end
end


function test_quasi_dct
    x = cos((1:16) * .1);
    alpha = SPX_DCT.inverse_quasi(x);
    y = SPX_DCT.forward_quasi(alpha(1:16));
end
