function test_suite = test_signals
  initTestSuite;
end

function test_picket_fence
    s = SPX_Signals.picket_fence(16);
    expected_s = [ 1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 ];
    assertEqual(s, s);
    fs = fft(s);
    assertEqual(SPX_Support.support(s), SPX_Support.support(fs));
    Ns = (1:100).^2;
    for N=Ns
        s = SPX_Signals.picket_fence(N);
        fs = fft(s);
        assertEqual(SPX_Support.support(s), SPX_Support.support(fs, 1e-8));
    end    
end

