function test_suite = test_cs_checks
  initTestSuite;
end


function test_is_square
    a = randn(3, 4);
    assertFalse(SPX_Checks.is_square(a));
    assertTrue(SPX_Checks.is_square(zeros(3, 3)));
end

function test_is_symmetric
    a  = randn(3, 4);
    assertFalse(SPX_Checks.is_symmetric(a));
    a = [1 2; 3 4];
    assertFalse(SPX_Checks.is_symmetric(a));
    a = [1 2; 2 4];
    assertTrue(SPX_Checks.is_symmetric(a));
    a = [1 2i; 2i 4];
    assertTrue(SPX_Checks.is_symmetric(a));
    a = [1 2i; -2i 4];
    assertFalse(SPX_Checks.is_symmetric(a));
end


function test_is_hermitian
    a  = randn(3, 4);
    assertFalse(SPX_Checks.is_hermitian(a));
    a = [1 2; 3 4];
    assertFalse(SPX_Checks.is_hermitian(a));
    a = [1 2; 2 4];
    assertTrue(SPX_Checks.is_hermitian(a));
    a = [1 2i; 2i 4];
    assertFalse(SPX_Checks.is_hermitian(a));
    a = [1 2i; -2i 4];
    assertTrue(SPX_Checks.is_hermitian(a));
end





function test_is_pd
    a = randn(3, 3);
    assertFalse(SPX_Checks.is_positive_definite(a));
    a  = [
    2 -1 0; 
    -1 2 -1;
    0 -1 2];
    assertTrue(SPX_Checks.is_positive_definite(a));
end




