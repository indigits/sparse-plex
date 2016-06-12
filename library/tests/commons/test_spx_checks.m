function tests = test_spx_checks
  tests = functiontests(localfunctions);
end

function setupOnce(testCase)
    import spx.commons.matrix;
end


function test_is_square(testCase)
    import spx.commons.matrix;
    a = randn(3, 4);
    verifyFalse(testCase, matrix.is_square(a));
    verifyTrue(testCase, matrix.is_square(zeros(3, 3)));
end

function test_is_symmetric(testCase)
    import spx.commons.matrix;
    a  = randn(3, 4);
    verifyFalse(testCase, matrix.is_symmetric(a));
    a = [1 2; 3 4];
    verifyFalse(testCase, matrix.is_symmetric(a));
    a = [1 2; 2 4];
    verifyTrue(testCase, matrix.is_symmetric(a));
    a = [1 2i; 2i 4];
    verifyTrue(testCase, matrix.is_symmetric(a));
    a = [1 2i; -2i 4];
    verifyFalse(testCase, matrix.is_symmetric(a));
end


function test_is_hermitian(testCase)
    import spx.commons.matrix;
    a  = randn(3, 4);
    verifyFalse(testCase, matrix.is_hermitian(a));
    a = [1 2; 3 4];
    verifyFalse(testCase, matrix.is_hermitian(a));
    a = [1 2; 2 4];
    verifyTrue(testCase, matrix.is_hermitian(a));
    a = [1 2i; 2i 4];
    verifyFalse(testCase, matrix.is_hermitian(a));
    a = [1 2i; -2i 4];
    verifyTrue(testCase, matrix.is_hermitian(a));
end





function test_is_pd(testCase)
    import spx.commons.matrix;
    a = randn(3, 3);
    verifyFalse(testCase, matrix.is_positive_definite(a));
    a  = [
    2 -1 0; 
    -1 2 -1;
    0 -1 2];
    verifyTrue(testCase, matrix.is_positive_definite(a));
end




