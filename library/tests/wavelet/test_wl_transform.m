function tests = test_wl_transform
  tests = functiontests(localfunctions);
end


function test_fwd_po_wavelet_transform(testCase)
    x = [0 5 -3 3 -4 -6 -1 6 1 -7 -2 -7 1 -8 1 -3];
    h = spx.wavelet.daubechies.quad_mirror_filter(20);
    L = 1;
    w = spx.wavelet.transform.forward_periodized_orthogonal(h, x, L);
    w_expected = [-0.886174910726689  -7.599106463564170  -4.126070413696197  -3.831372392026132...
    -1.964972811707912  -6.298466192390180  -5.868195699184612   3.365505053418349...
    -3.291527529820000   3.514441633073000   5.705304137811999  -1.015576057620000...
    1.086658992536000  -1.158475051501000  -6.297575180086999  -5.614318756272999];
    verifyEqual(testCase, w, w_expected, 'AbsTol', 1e-6);
    verifyEqual(testCase, norm(x), norm(w), 'AbsTol', 1e-6);
    x = x';
    w = spx.wavelet.transform.forward_periodized_orthogonal(h, x, L);
    verifyEqual(testCase, w, w_expected', 'AbsTol', 1e-6);
    verifyEqual(testCase, norm(x), norm(w), 'AbsTol', 1e-6);

    % We now restrict L to 2
    L = 2;
    x = x';
    w = spx.wavelet.transform.forward_periodized_orthogonal(h, x, L);
    w_expected = [0.004217817988112  -9.167655098625628  -0.377456049193954  -2.459106670217828...
    -1.964972811707912  -6.298466192390180  -5.868195699184612   3.365505053418349...
    -3.291527529820000   3.514441633073000   5.705304137811999  -1.015576057620000...
    1.086658992536000  -1.158475051501000  -6.297575180086999  -5.614318756272999];
    verifyEqual(testCase, w, w_expected, 'AbsTol', 1e-6);
    verifyEqual(testCase, norm(x), norm(w), 'AbsTol', 1e-6);
    x = x';
    w = spx.wavelet.transform.forward_periodized_orthogonal(h, x, L);
    verifyEqual(testCase, w, w_expected', 'AbsTol', 1e-6);
    verifyEqual(testCase, norm(x), norm(w), 'AbsTol', 1e-6);
end


function test_inv_po_wavelet_transform(testCase)
    x = [0 5 -3 3 -4 -6 -1 6 1 -7 -2 -7 1 -8 1 -3];
    h = spx.wavelet.daubechies.quad_mirror_filter(20);
    L = 1;
    w = spx.wavelet.transform.forward_periodized_orthogonal(h, x, L);
    y = spx.wavelet.transform.inverse_periodized_orthogonal(h, w, L);
    verifyEqual(testCase, x, y, 'AbsTol', 1e-6);
end
