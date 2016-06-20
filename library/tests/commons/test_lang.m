function tests = test_lang
  tests = functiontests(localfunctions);
end

function test_1(testCase)
    verifyTrue(testCase, spx.lang.is_class('spx.lang'));
    verifyFalse(testCase, spx.lang.is_class('spx.lang.noop'));
    spx.lang.noop;
end
