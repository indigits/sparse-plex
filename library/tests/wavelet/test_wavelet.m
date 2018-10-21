function tests = test_wavelet
  tests = functiontests(localfunctions);
end

function test_dyad(testCase)
    verifyEqual(testCase, spx.wavelet.dyad(0) , 2:2);
    verifyEqual(testCase, spx.wavelet.dyad(1) , 3:4);
    verifyEqual(testCase, spx.wavelet.dyad(2) , 5:8);
    verifyEqual(testCase, spx.wavelet.dyad(3) , 9:16);
    verifyEqual(testCase, spx.wavelet.dyad(4) , 17:32);
end

function test_is_dyadic(testCase)
    for k=0:0
        verifyTrue(testCase, spx.wavelet.is_dyadic(0, k));
    end
    verifyFalse(testCase, spx.wavelet.is_dyadic(0, k+1));

    for k=0:1
        verifyTrue(testCase, spx.wavelet.is_dyadic(1, k));
    end
    verifyFalse(testCase, spx.wavelet.is_dyadic(1, k+1));

    for k=0:3
        verifyTrue(testCase, spx.wavelet.is_dyadic(2, k));
    end
    verifyFalse(testCase, spx.wavelet.is_dyadic(2, k+1));

    for k=0:7
        verifyTrue(testCase, spx.wavelet.is_dyadic(3, k));
    end
    verifyFalse(testCase, spx.wavelet.is_dyadic(3, k+1));

    for k=0:15
        verifyTrue(testCase, spx.wavelet.is_dyadic(4, k));
    end
    verifyFalse(testCase, spx.wavelet.is_dyadic(4, k+1));

end

function test_dyad_to_index(testCase)
    verifyEqual(testCase, spx.wavelet.dyad_to_index(0, [0]), 2:2);
    verifyEqual(testCase, spx.wavelet.dyad_to_index(1, 0:1), 3:4);
    verifyEqual(testCase, spx.wavelet.dyad_to_index(2, 0:3), 5:8);
    verifyEqual(testCase, spx.wavelet.dyad_to_index(3, 0:7), 9:16);
end

function test_dyad_length(testCase)
    [n , j, f] = spx.wavelet.dyad_length(0:1);
    verifyEqual(testCase, [n , j, f], [2, 1, 1]);
    [n , j, f] = spx.wavelet.dyad_length(0:3);
    verifyEqual(testCase, [n , j, f], [4, 2, 1]);
    [n , j, f] = spx.wavelet.dyad_length(0:7);
    verifyEqual(testCase, [n , j, f], [8, 3, 1]);
    [n , j, f] = spx.wavelet.dyad_length(0:15);
    verifyEqual(testCase, [n , j, f], [16, 4, 1]);
    % Bad cases
    [n , j, f] = spx.wavelet.dyad_length(0:16);
    verifyEqual(testCase, [n , j, f], [17, 5, 0]);
end


function test_cut_dyad(testCase)
    x  = [1 2 3 4 5];
    y = spx.wavelet.cut_dyadic(x);
    verifyEqual(testCase, y, 1:4);
    x = x';
    y = spx.wavelet.cut_dyadic(x);
    verifyEqual(testCase, y, (1:4)');
end


function test_aconv(testCase)
    x = [-1 0 2 1];
    f = [.2 .2];
    y = spx.wavelet.aconv(f , x);
    y0 = [-.2 .4 .6 0];
    assertVectorsAlmostEqual(y, y0);
    assertVectorsAlmostEqual(spx.wavelet.aconv(f' , x), y0);
    assertVectorsAlmostEqual(spx.wavelet.aconv(f , x'), y0');
    assertVectorsAlmostEqual(spx.wavelet.aconv(f' , x'), y0');


    x = [-1 0 2 1];
    f = [.2 .2 .2 .2 .2];
    y = spx.wavelet.aconv(f , x);
    y0 = [.2 .4 .8 .6];
    assertVectorsAlmostEqual(y, y0);
    assertVectorsAlmostEqual(spx.wavelet.aconv(f' , x), y0);
    assertVectorsAlmostEqual(spx.wavelet.aconv(f , x'), y0');
    assertVectorsAlmostEqual(spx.wavelet.aconv(f' , x'), y0');
end


function test_iconv(testCase)
    x = [-1 0 2 1];
    f = [.2 .2];
    y = spx.wavelet.iconv(f , x);
    y0 = [ 0 -.2 .4 .6];
    assertVectorsAlmostEqual(y, y0);
    assertVectorsAlmostEqual(spx.wavelet.iconv(f' , x), y0);
    assertVectorsAlmostEqual(spx.wavelet.iconv(f , x'), y0');
    assertVectorsAlmostEqual(spx.wavelet.iconv(f' , x'), y0');


    x = [-1 0 2 1];
    f = [.2 .2 .2 .2 .2];
    y = spx.wavelet.iconv(f , x);
    y0 = [.2 .4 .8 .6];
    assertVectorsAlmostEqual(y, y0);
    assertVectorsAlmostEqual(spx.wavelet.iconv(f' , x), y0);
    assertVectorsAlmostEqual(spx.wavelet.iconv(f , x'), y0');
    assertVectorsAlmostEqual(spx.wavelet.iconv(f' , x'), y0');
end


function test_mirror_filter(testCase)
    h = spx.wavelet.haar.quad_mirror_filter;
    g = spx.wavelet.mirror_filter(h);
    verifyEqual(testCase, g, [1 -1] ./ sqrt(2));
    h2 = spx.wavelet.mirror_filter(g);
    verifyEqual(testCase, h2, h);
    h = spx.wavelet.daubechies.quad_mirror_filter(20);
    g = spx.wavelet.mirror_filter(h);
    h2 = spx.wavelet.mirror_filter(g);
    verifyEqual(testCase, h2, h);
    h = ones(1, 10);
    g = spx.wavelet.mirror_filter(h);
    verifyEqual(testCase, sum(h  == g), 5);
    a= ones(1, 5);
    b = [a ; -a];
    c = b(:)';
    verifyEqual(testCase, c, g);
end

function test_upsample(testCase)
    x = [1 2 3];
    y = spx.wavelet.up_sample(x);
    verifyEqual(testCase, y, [1 0 2 0 3 0]);
    y = spx.wavelet.up_sample(x, 3);
    verifyEqual(testCase, y, [1 0 0 2 0 0 3 0 0]);
end



function test_hi_pass_down_sample(testCase)
    h = spx.wavelet.daubechies.quad_mirror_filter(20);
    x = [1 -1  2 -2  3 -3  4 -4  3 -3  2 -2  1 -1  2 -2];
    y0 = [-2.605103540984999  -1.674153156387000  -2.989131414576999  -4.540466300308999...
      -5.490742088699001  -4.031099687953000 -2.537344480928999  -1.587803452929000];
    y = spx.wavelet.hi_pass_down_sample(h, x);
    assertVectorsAlmostEqual(y, y0);
end


function test_lo_pass_down_sample(testCase)
    h = spx.wavelet.daubechies.quad_mirror_filter(20);
    x = [1 -1  2 -2  3 -3  4 -4  3 -3  2 -2  1 -1  2 -2];
    y0 = [0.196575453299000   0.640838188043000  -0.132150600147000  -0.099914489637000...
      -0.844400789821000   0.449878806033000 -0.315491816913000   0.104665249143000];
    y = spx.wavelet.lo_pass_down_sample(h, x);
    assertVectorsAlmostEqual(y, y0);
end



function test_up_sample_low_pass(testCase)
    h = spx.wavelet.daubechies.quad_mirror_filter(20);
    x = [1    -1     2    -2 ];
    y0 = [-0.112524198664000  -1.977171657814000  -0.579863964746000   1.384874954135000...
       0.414126633328000  -1.007629168268000 0.278261530082000   1.599925871947000];
    y = spx.wavelet.up_sample_lo_pass(h, x);
    assertVectorsAlmostEqual(y, y0);
end


function test_up_sample_hi_pass(testCase)
    h = spx.wavelet.daubechies.quad_mirror_filter(20);
    x = [1    -1     2    -2 ];
    y0 = [1.384874954135000   0.579863964746000  -1.977171657814000   0.112524198664000...
       1.599925871947000  -0.278261530082000 -1.007629168268000  -0.414126633328000];
    y = spx.wavelet.up_sample_hi_pass(h, x);
    assertVectorsAlmostEqual(y, y0);
end

