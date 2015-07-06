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
