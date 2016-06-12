function test_suite = test_it
  initTestSuite;
end


function test_entropy
    data = [0 0 0 1 1 1 2 2 2 3 3 3];
    h = SPX_IT.entropy(data);
    assertElementsAlmostEqual(h, 2.0);
end
