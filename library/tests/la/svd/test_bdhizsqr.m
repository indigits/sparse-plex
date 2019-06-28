function tests = test_bdhizsqr
  tests = functiontests(localfunctions);
end


function verify_bd_full_svd(a, b, testCase)
    n = numel(a);
    A = full(spdiags([a [0; b]], [0 1], n, n));
    [UU, SS, VV] = svd(A);
    options.verbosity = 0;
    [U, S, V] = spx.fast.bdhizsqr_svd(a,b, options);
    verifyEqual(testCase, full(diag(S)), diag(SS), 'AbsTol', 1e-12);
    verifyEqual(testCase, spx.la.nonorthogonality(U), 0, 'AbsTol', 1e-12);
    verifyEqual(testCase, spx.la.nonorthogonality(V), 0, 'AbsTol', 1e-12);
    AA = U * S * V';
    verifyEqual(testCase, A, AA, 'AbsTol', 1e-12);
    verifyEqual(testCase, abs(U), abs(UU), 'AbsTol', 1e-12);
end

function verify_only_singular_values(a, b, testCase)
    n = numel(a);
    A = full(spdiags([a [0; b]], [0 1], n, n));
    SS = svd(A);
    S = spx.fast.bdhizsqr_svd(a,b);
    verifyEqual(testCase, S, SS, 'AbsTol', 1e-12);
end

function verify_u_last_row(a, b, testCase)
    n = numel(a);
    A = full(spdiags([a [0; b]], [0 1], n, n));
    [UU, SS, VV] = svd(A);
    options.u_rows = [n];
    [U, S] = spx.fast.bdhizsqr_svd(a,b, options);
    verifyEqual(testCase, S, diag(SS), 'AbsTol', 1e-12);
    U2 = UU(end, :);
    verifyEqual(testCase, abs(U), abs(U2), 'AbsTol', 1e-12);
end

function test_last_row(testCase)
    a = [1/2 1/4 1/8 1/16 1/32 1/64]'; b = [1 2 -1 -2 1]';
    verify_u_last_row(a, b, testCase);
    a = [1 2 3 3 2 1]'; b = [1 2 -1 -2 1]';
    verify_u_last_row(a, b, testCase);
    a = [1 2 3 4 5 6]'; b = [1 2 -1 -2 1]';
    verify_u_last_row(a, b, testCase);
    a = [1/2 1/4 1/8 1/16 1/32 1/64]'; b = [1 2 -1 -2 1]';
    verify_u_last_row(a, b, testCase);
end

function test_only_singular_values(testCase)
    a = [1 2 3 3 2 1]'; b = [1 2 -1 -2 1]';
    verify_only_singular_values(a, b, testCase);
    a = [1 2 3 4 5 6]'; b = [1 2 -1 -2 1]';
    verify_only_singular_values(a, b, testCase);
    a = [1/2 1/4 1/8 1/16 1/32 1/64]'; b = [1 2 -1 -2 1]';
    verify_only_singular_values(a, b, testCase);
end

function test_1(testCase)
    a = [1 2 3 3 2 1]'; b = [1 2 -1 -2 1]';
    verify_bd_full_svd(a, b, testCase);
end

function test_2(testCase)
    a = [1 2 3 4 5 6]'; b = [1 2 -1 -2 1]';
    verify_bd_full_svd(a, b, testCase);
end

function test_3(testCase)
    a = [1/2 1/4 1/8 1/16 1/32 1/64]'; b = [1 2 -1 -2 1]';
    verify_bd_full_svd(a, b, testCase);
end

function test_4(testCase)
    a = [1/64 1/32 1/16 1/8 1/4 1/2]'; b = [1 2 -1 -2 1]';
    verify_bd_full_svd(a, b, testCase);
end

function test_5(testCase)
    a = ones(6, 1); b = zeros(5, 1);
    verify_bd_full_svd(a, b, testCase);
end
function test_6(testCase)
    a = [1 1 1/100]'; b = [0  1]';
    verify_bd_full_svd(a, b, testCase);
end
function test_7(testCase)
    a = [-1 1 1/100]'; b = [0  -1]';
    verify_bd_full_svd(a, b, testCase);
end
function test_8(testCase)
    a = [-1 1/10 1/100]'; b = [.1 -.1]';
    verify_bd_full_svd(a, b, testCase);
end
function test_9(testCase)
    a = [1/100 -1/10 1]'; b = [-.1 .1]';
    verify_bd_full_svd(a, b, testCase);
end


function test_10(testCase)
    alpha = [2.0074 1.3912 0.9620 0.9705 1.1207 1.1491 1.0648 1.0474 0.9001 1.0274 1.0713 1.0241 1.0928 0.9850 1.0605 1.1760 0.9556 1.0401 1.2332 1.0288 0.9445 1.0836 1.0105 0.9715 1.1755 1.1439 0.9918 1.0790 1.0017 0.9292 1.0069 1.1838 0.9330 0.8743 0.9705 0.9932 0.9413 0.8130 0.8581 1.0076 0.9950 0.8767 0.9045 0.7637 0.8717 0.8697 0.8927 0.9939 0.9285 0.8069 0.8440 0.8879 0.8060 0.8034 0.8054 0.8393 0.8068 0.8077 0.8563 0.7771 0.8622 0.8232 0.8499 0.8687 0.8052 0.8193 0.0000]';
    beta =  [0.3983 1.0517 0.9578 1.1050 0.9405 0.9720 1.1747 1.0656 0.8632 1.1029 1.0015 0.9553 1.0921 1.0258 0.9547 1.0230 0.9264 1.0586 1.0231 0.8917 0.9671 0.9876 0.9214 0.9514 1.0351 1.0116 0.9881 0.9670 0.8618 0.9276 1.1199 1.0183 0.9144 0.8964 0.9943 0.9560 0.8559 0.9272 0.8591 1.0369 0.9838 0.8429 0.8651 0.8713 0.8399 0.9075 1.0259 0.9556 0.8768 0.8669 0.7960 0.8196 0.8519 0.8619 0.8613 0.7670 0.8661 0.8501 0.7928 0.8507 0.8567 0.8357 0.7723 0.8556 0.8403 0.8092]';
    n = numel(alpha);
    for i=2:6:n
        a = alpha(1:i);
        b = beta(1:i-1);
        verify_bd_full_svd(a, b, testCase);
    end
end

