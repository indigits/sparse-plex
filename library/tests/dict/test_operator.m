function tests = test_operator
  tests = functiontests(localfunctions);
end

function test_1(testCase)
    b = [ 1 2 3; 3 4 3];
    bb = spx.dict.MatrixOperator(b);
    [m, n] = size(bb);
    verifyEqual(testCase, [m, n], size(b));
    bbb = double(bb);
    verifyEqual(testCase, bbb, b);
    v = [1 2 3]';
    verifyEqual(testCase, b*v, bb*v);
    v = [1 2]';
    verifyEqual(testCase, b'*v, bb'*v);
    c = bb';
    verifyEqual(testCase, b', c.A);
    c = bb.';
    verifyEqual(testCase, b.', c.A);
    b2 = bb.columns_operator([1 2]);
    verifyEqual(testCase, double(b2), b(:, [1 2]));
end


function test_dct_basis(testCase)
    N = 4;
    Dict = spx.dict.DCTBasis(N);
    A = double(Dict);
    
    tolerance = 1e-10;
    verifyEqual(testCase, A, dctmtx(N)', 'AbsTol', tolerance);

    tolerance = 1e-3;
    x = [1 1 1 1]';
    y = Dict * x;
    verifyEqual(testCase, y, [1.9239
   -0.3827
    0.3827
    0.0761], 'AbsTol', tolerance);

    x = [1 1 1 1]';
    y = Dict.apply_transpose(x);
    verifyEqual(testCase, y, [2.0000
         0
         0
         0], 'AbsTol', tolerance);
    y = Dict.adjoint(x);
    verifyEqual(testCase, y, [2.0000
         0
         0
         0], 'AbsTol', tolerance);

end


function test_dft_basis(testCase)
    N = 4;
    Dict = spx.dict.DFTBasis(N);
    A = double(Dict);
    
    tolerance = 1e-10;
    verifyEqual(testCase, A, dftmtx(N)' / sqrt(N), 'AbsTol', tolerance);

    A = Dict.apply(eye(4));
    verifyEqual(testCase, A, dftmtx(N)' / sqrt(N), 'AbsTol', tolerance);

    A = Dict.adjoint(eye(4));
    verifyEqual(testCase, A, dftmtx(N) / sqrt(N), 'AbsTol', tolerance);


    tolerance = 1e-3;
    x = [1 1 1 1]';
    y = Dict * x;
    verifyEqual(testCase, y, [2
     0
     0
     0], 'AbsTol', tolerance);

    x = [1 1 1 1]';
    y = Dict.apply_transpose(x);
    verifyEqual(testCase, y, [2.0000
         0
         0
         0], 'AbsTol', tolerance);
    y = Dict.adjoint(x);
    verifyEqual(testCase, y, [2.0000
         0
         0
         0], 'AbsTol', tolerance);

end


function test_partial_dct_1(testCase)
    rng default;
    M = 2;
    N = 4;
    p = randperm(N);
    % select some rows randomly
    row_pics = sort(p(1:M));
    % make sure that the first row is there
    row_pics(1) = 1;
    col_perm = randperm(N);
    Dict = spx.dict.PartialDCT(row_pics, col_perm);
    x = ones(N, 1);
    y  = Dict.apply(x);
    z = Dict.adjoint(y);
    tolerance = 1e-3;
    verifyEqual(testCase, y, [2.0000
         0], 'AbsTol', tolerance);
    verifyEqual(testCase, z, [1.0000
    1.0000
    1.0000
    1.0000], 'AbsTol', tolerance);

    x(1) = x(1) + 2;
    y  = Dict.apply(x);
    z = Dict.adjoint(y);
    verifyEqual(testCase, y, [3.0000
    1.0000], 'AbsTol', tolerance);
    verifyEqual(testCase, z, [2.0000
    2.0000
    1.0000
    1.0000], 'AbsTol', tolerance);

end

function test_partial_dct_orthogonal(testCase)
    rng default;
    M = 32;
    N = 64;
    p = randperm(N);
    % select some rows randomly
    row_pics = sort(p(1:M));
    % make sure that the first row is there
    row_pics(1) = 1;
    col_perm = randperm(N);
    Dict = spx.dict.PartialDCT(row_pics, col_perm);
    y = eye(M);
    z = Dict.adjoint(y);
    u = Dict.apply(z);
    tolerance = 1e-8;
    verifyEqual(testCase, y, u, 'AbsTol', tolerance);
end
