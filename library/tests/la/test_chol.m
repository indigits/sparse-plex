function tests = test_spaces
  tests = functiontests(localfunctions);
end

function test_chol_update1(testCase)
    n = 5;
    A  = gallery('moler', n);
    L = sqrt(A(1,1));
    for c = 2:n
        % pick c elements from c-th column
        atom = A(1:c, c);
        L = spx.la.chol.chol_update(L, atom);
        estimate = L * L';
        verifyEqual(testCase, A(1:c, 1:c), estimate, 'AbsTol', 1e-6);
    end
end


function test_chol_update2(testCase)
    n = 10;
    D  = randn(n, n);
    A = D'*D;
    L = [];
    for c = 1:n
        % pick c elements from c-th column
        atom = A(1:c, c);
        L = spx.la.chol.chol_update(L, atom);
        estimate = L * L';
        verifyEqual(testCase, A(1:c, 1:c), estimate, 'AbsTol', 1e-6);
    end
end