function test_suite = test_wavelet
  initTestSuite;
end

function test_dyad
    assertEqual(SPX_Wavelet.dyad(0) , 2:2);
    assertEqual(SPX_Wavelet.dyad(1) , 3:4);
    assertEqual(SPX_Wavelet.dyad(2) , 5:8);
    assertEqual(SPX_Wavelet.dyad(3) , 9:16);
    assertEqual(SPX_Wavelet.dyad(4) , 17:32);
end

function test_is_dyadic
    for k=0:0
        assertTrue(SPX_Wavelet.is_dyadic(0, k));
    end
    assertFalse(SPX_Wavelet.is_dyadic(0, k+1));

    for k=0:1
        assertTrue(SPX_Wavelet.is_dyadic(1, k));
    end
    assertFalse(SPX_Wavelet.is_dyadic(1, k+1));

    for k=0:3
        assertTrue(SPX_Wavelet.is_dyadic(2, k));
    end
    assertFalse(SPX_Wavelet.is_dyadic(2, k+1));

    for k=0:7
        assertTrue(SPX_Wavelet.is_dyadic(3, k));
    end
    assertFalse(SPX_Wavelet.is_dyadic(3, k+1));

    for k=0:15
        assertTrue(SPX_Wavelet.is_dyadic(4, k));
    end
    assertFalse(SPX_Wavelet.is_dyadic(4, k+1));

end

function test_dyad_to_index
    assertEqual(SPX_Wavelet.dyad_to_index(0, [0]), 2:2);
    assertEqual(SPX_Wavelet.dyad_to_index(1, 0:1), 3:4);
    assertEqual(SPX_Wavelet.dyad_to_index(2, 0:3), 5:8);
    assertEqual(SPX_Wavelet.dyad_to_index(3, 0:7), 9:16);
end

function test_dyad_length
    [n , j, f] = SPX_Wavelet.dyad_length(0:1);
    assertEqual([n , j, f], [2, 1, 1]);
    [n , j, f] = SPX_Wavelet.dyad_length(0:3);
    assertEqual([n , j, f], [4, 2, 1]);
    [n , j, f] = SPX_Wavelet.dyad_length(0:7);
    assertEqual([n , j, f], [8, 3, 1]);
    [n , j, f] = SPX_Wavelet.dyad_length(0:15);
    assertEqual([n , j, f], [16, 4, 1]);
    % Bad cases
    [n , j, f] = SPX_Wavelet.dyad_length(0:16);
    assertEqual([n , j, f], [17, 5, 0]);
end


function test_cut_dyad
    x  = [1 2 3 4 5];
    y = SPX_Wavelet.cut_dyadic(x);
    assertEqual(y, 1:4);
    x = x';
    y = SPX_Wavelet.cut_dyadic(x);
    assertEqual(y, (1:4)');
end


function test_aconv
    x = [-1 0 2 1];
    f = [.2 .2];
    y = SPX_Wavelet.aconv(f , x);
    y0 = [-.2 .4 .6 0];
    assertVectorsAlmostEqual(y, y0);
    assertVectorsAlmostEqual(SPX_Wavelet.aconv(f' , x), y0);
    assertVectorsAlmostEqual(SPX_Wavelet.aconv(f , x'), y0');
    assertVectorsAlmostEqual(SPX_Wavelet.aconv(f' , x'), y0');


    x = [-1 0 2 1];
    f = [.2 .2 .2 .2 .2];
    y = SPX_Wavelet.aconv(f , x);
    y0 = [.2 .4 .8 .6];
    assertVectorsAlmostEqual(y, y0);
    assertVectorsAlmostEqual(SPX_Wavelet.aconv(f' , x), y0);
    assertVectorsAlmostEqual(SPX_Wavelet.aconv(f , x'), y0');
    assertVectorsAlmostEqual(SPX_Wavelet.aconv(f' , x'), y0');
end


function test_iconv
    x = [-1 0 2 1];
    f = [.2 .2];
    y = SPX_Wavelet.iconv(f , x);
    y0 = [ 0 -.2 .4 .6];
    assertVectorsAlmostEqual(y, y0);
    assertVectorsAlmostEqual(SPX_Wavelet.iconv(f' , x), y0);
    assertVectorsAlmostEqual(SPX_Wavelet.iconv(f , x'), y0');
    assertVectorsAlmostEqual(SPX_Wavelet.iconv(f' , x'), y0');


    x = [-1 0 2 1];
    f = [.2 .2 .2 .2 .2];
    y = SPX_Wavelet.iconv(f , x);
    y0 = [.2 .4 .8 .6];
    assertVectorsAlmostEqual(y, y0);
    assertVectorsAlmostEqual(SPX_Wavelet.iconv(f' , x), y0);
    assertVectorsAlmostEqual(SPX_Wavelet.iconv(f , x'), y0');
    assertVectorsAlmostEqual(SPX_Wavelet.iconv(f' , x'), y0');
end


function test_mirror_filter
    h = SPX_HaarWavelet.on_qmf_filter;
    g = SPX_Wavelet.mirror_filter(h);
    assertEqual(g, [1 -1] ./ sqrt(2));
    h2 = SPX_Wavelet.mirror_filter(g);
    assertEqual(h2, h);
    h = SPX_DaubechiesWavelet.on_qmf_filter(20);
    g = SPX_Wavelet.mirror_filter(h);
    h2 = SPX_Wavelet.mirror_filter(g);
    assertEqual(h2, h);
    h = ones(1, 10);
    g = SPX_Wavelet.mirror_filter(h);
    assertEqual(sum(h  == g), 5);
    a= ones(1, 5);
    b = [a ; -a];
    c = b(:)';
    assertEqual(c, g);
end

function test_upsample
    x = [1 2 3];
    y = SPX_Wavelet.up_sample(x);
    assertEqual(y, [1 0 2 0 3 0]);
    y = SPX_Wavelet.up_sample(x, 3);
    assertEqual(y, [1 0 0 2 0 0 3 0 0]);
end



function test_hi_pass_down_sample
    h = SPX_DaubechiesWavelet.on_qmf_filter(20);
    x = [1 -1  2 -2  3 -3  4 -4  3 -3  2 -2  1 -1  2 -2];
    y0 = [-2.605103540984999  -1.674153156387000  -2.989131414576999  -4.540466300308999...
      -5.490742088699001  -4.031099687953000 -2.537344480928999  -1.587803452929000];
    y = SPX_Wavelet.hi_pass_down_sample(h, x);
    assertVectorsAlmostEqual(y, y0);
end


function test_lo_pass_down_sample
    h = SPX_DaubechiesWavelet.on_qmf_filter(20);
    x = [1 -1  2 -2  3 -3  4 -4  3 -3  2 -2  1 -1  2 -2];
    y0 = [0.196575453299000   0.640838188043000  -0.132150600147000  -0.099914489637000...
      -0.844400789821000   0.449878806033000 -0.315491816913000   0.104665249143000];
    y = SPX_Wavelet.lo_pass_down_sample(h, x);
    assertVectorsAlmostEqual(y, y0);
end



function test_up_sample_low_pass
    h = SPX_DaubechiesWavelet.on_qmf_filter(20);
    x = [1    -1     2    -2 ];
    y0 = [-0.112524198664000  -1.977171657814000  -0.579863964746000   1.384874954135000...
       0.414126633328000  -1.007629168268000 0.278261530082000   1.599925871947000];
    y = SPX_Wavelet.up_sample_lo_pass(h, x);
    assertVectorsAlmostEqual(y, y0);
end


function test_up_sample_hi_pass
    h = SPX_DaubechiesWavelet.on_qmf_filter(20);
    x = [1    -1     2    -2 ];
    y0 = [1.384874954135000   0.579863964746000  -1.977171657814000   0.112524198664000...
       1.599925871947000  -0.278261530082000 -1.007629168268000  -0.414126633328000];
    y = SPX_Wavelet.up_sample_hi_pass(h, x);
    assertVectorsAlmostEqual(y, y0);
end

