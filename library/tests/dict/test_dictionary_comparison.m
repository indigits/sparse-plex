function tests = test_dictionary_comparison
  tests = functiontests(localfunctions);
end


function test_1(testCase)
    d = spx.dict.simple.dirac_fourier_mtx(16);
    ratio = spx.dict.comparison.matching_atoms_ratio(d, d);
    verifyEqual(testCase, ratio, 1);
    % Let's mess up with one of the atoms
    d2 = d;
    d2(1:4, 1) = 1/2;
    ratio = spx.dict.comparison.matching_atoms_ratio(d, d2);
    verifyEqual(testCase, ratio, 31/32);
    d2(2:5, 2) = 1/2;
    ratio = spx.dict.comparison.matching_atoms_ratio(d, d2);
    verifyEqual(testCase, ratio, 30/32);
end

