function tests = test_dst
  tests = functiontests(localfunctions);
end


function test_dst_1(testCase)
    x = cos((1:15) * .1);
    alpha = spx.dsp.dst.forward_1(x);
    y = spx.dsp.dst.inverse_1(alpha);
    tolerance = 1e-6;
    verifyEqual(testCase, x, y, 'AbsTol', tolerance);
end


function test_dst_2(testCase)
    n = 256;
    tolerance = 1e-6;
    for i=randperm(n, 40)
        x = spx.vector.unit_vector(n, i);
        alpha = spx.dsp.dst.forward_2(x);
        verifyEqual(testCase, norm(x), norm(alpha), 'AbsTol', tolerance);
        y = spx.dsp.dst.inverse_2(alpha);
        verifyEqual(testCase, norm(y), norm(alpha), 'AbsTol', tolerance);
        verifyEqual(testCase, x, y, 'AbsTol', tolerance);
        alpha = spx.dsp.dst.forward_3(x);
        verifyEqual(testCase, norm(x), norm(alpha), 'AbsTol', tolerance);
        y = spx.dsp.dst.inverse_3(alpha);
        verifyEqual(testCase, norm(y), norm(alpha), 'AbsTol', tolerance);
        verifyEqual(testCase, x, y, 'AbsTol', tolerance);
    end
end
