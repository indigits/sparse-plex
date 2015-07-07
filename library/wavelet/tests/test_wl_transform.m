function test_suite = test_wl_transform
  initTestSuite;
end


function test_fwd_po_wavelet_transform
    x = [0 5 -3 3 -4 -6 -1 6 1 -7 -2 -7 1 -8 1 -3];
    h = SPX_DaubechiesWavelet.quad_mirror_filter(20);
    L = 1;
    w = SPX_WaveletTransform.forward_periodized_orthogonal(h, x, L);
    w_expected = [-0.886174910726689  -7.599106463564170  -4.126070413696197  -3.831372392026132...
    -1.964972811707912  -6.298466192390180  -5.868195699184612   3.365505053418349...
    -3.291527529820000   3.514441633073000   5.705304137811999  -1.015576057620000...
    1.086658992536000  -1.158475051501000  -6.297575180086999  -5.614318756272999];
    assertVectorsAlmostEqual(w, w_expected);
    assertElementsAlmostEqual(norm(x), norm(w));
    x = x';
    w = SPX_WaveletTransform.forward_periodized_orthogonal(h, x, L);
    assertVectorsAlmostEqual(w, w_expected');
    assertElementsAlmostEqual(norm(x), norm(w));

    % We now restrict L to 2
    L = 2;
    x = x';
    w = SPX_WaveletTransform.forward_periodized_orthogonal(h, x, L);
    w_expected = [0.004217817988112  -9.167655098625628  -0.377456049193954  -2.459106670217828...
    -1.964972811707912  -6.298466192390180  -5.868195699184612   3.365505053418349...
    -3.291527529820000   3.514441633073000   5.705304137811999  -1.015576057620000...
    1.086658992536000  -1.158475051501000  -6.297575180086999  -5.614318756272999];
    assertVectorsAlmostEqual(w, w_expected);
    assertElementsAlmostEqual(norm(x), norm(w));
    x = x';
    w = SPX_WaveletTransform.forward_periodized_orthogonal(h, x, L);
    assertVectorsAlmostEqual(w, w_expected');
    assertElementsAlmostEqual(norm(x), norm(w));
end


function test_inv_po_wavelet_transform
    x = [0 5 -3 3 -4 -6 -1 6 1 -7 -2 -7 1 -8 1 -3];
    h = SPX_DaubechiesWavelet.quad_mirror_filter(20);
    L = 1;
    w = SPX_WaveletTransform.forward_periodized_orthogonal(h, x, L);
    y = SPX_WaveletTransform.inverse_periodized_orthogonal(h, w, L);
    assertVectorsAlmostEqual(x, y);
end
