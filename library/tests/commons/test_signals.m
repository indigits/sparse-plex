
function tests = test_signals
  tests = functiontests(localfunctions);
end

function test_picket_fence(testCase)
    import spx.data.signals.simple.picket_fence;
    import spx.commons.sparse.support;
    s = picket_fence(16);
    expected_s = [ 1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 ];
    verifyEqual(testCase, s, s);
    fs = fft(s);
    verifyEqual(testCase, support(s), support(fs));
    Ns = (1:100).^2;
    for N=Ns
        s = picket_fence(N);
        fs = fft(s);
        verifyEqual(testCase, support(s), support(fs, 1e-8));
    end    
end

