function tests = test_dct
  tests = functiontests(localfunctions);
end

function test_dct_2_3(testCase)
    n = 256;
    for i=randperm(n, 40)
        x = spx.vector.unit_vector(n, i);
        alpha = spx.dsp.dct.forward_2(x);
        tolerance = 0.0001;
        verifyEqual(testCase, norm(x), norm(alpha), 'AbsTol', tolerance);
        y = spx.dsp.dct.inverse_2(alpha);
        verifyEqual(testCase, norm(y), norm(alpha), 'AbsTol', tolerance);
        verifyEqual(testCase, x, y, 'AbsTol', tolerance);
        alpha = spx.dsp.dct.forward_3(x);
        verifyEqual(testCase, norm(x), norm(alpha), 'AbsTol', tolerance);
        y = spx.dsp.dct.inverse_3(alpha);
        verifyEqual(testCase, norm(y), norm(alpha), 'AbsTol', tolerance);
        verifyEqual(testCase, x, y, 'AbsTol', tolerance);
    end
    x  = cos(1:n);
    alpha1 = spx.dsp.dct.forward_2(x);
    alpha2 = dct(x);
    verifyEqual(testCase, alpha1, alpha2, 'RelTol', tolerance);
    y1 = spx.dsp.dct.inverse_2(alpha1);
    y2 = idct(alpha2); 
    verifyEqual(testCase, y1, y2, 'RelTol', tolerance);
end


function test_dct_basis_strang(testCase)
    n = 256;
    d1 = spx.dsp.dct.basis_strang(n, 2);
    d2 = dctmtx(n)';
    tolerance = 0.0001;
    for i=1:n
        v1 = d1(:, i);
        v2 = d2(:, i);
        if (v1(1) > 0)  & (v2(1) > 0)
            verifyEqual(testCase, v1, v2, 'AbsTol', tolerance);
        else
            verifyEqual(testCase, v1, -v2, 'AbsTol', tolerance);
        end
    end
end


function test_quasi_dct(testCase)
    x = cos((1:16) * .1);
    alpha = spx.dsp.dct.inverse_quasi(x);
    y = spx.dsp.dct.forward_quasi(alpha(1:16));
end
