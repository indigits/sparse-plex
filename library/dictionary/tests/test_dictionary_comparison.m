function test_suite = test_dictionary_comparison
  initTestSuite;
end


function test_1
    d = SPX_SimpleDicts.dirac_fourier_mtx(16);
    ratio = SPX_DictionaryComparison.matching_atoms_ratio(d, d);
    assertEqual(ratio, 1);
    % Let's mess up with one of the atoms
    d2 = d;
    d2(1:4, 1) = 1/2;
    ratio = SPX_DictionaryComparison.matching_atoms_ratio(d, d2);
    assertEqual(ratio, 31/32);
    d2(2:5, 2) = 1/2;
    ratio = SPX_DictionaryComparison.matching_atoms_ratio(d, d2);
    assertEqual(ratio, 30/32);
end

