
function runalltests(all)
    if nargin < 1
        all = false;
    else
    end

    import matlab.unittest.TestSuite;
    import matlab.unittest.selectors.HasTag;


    suite = TestSuite.fromFolder(pwd, 'IncludingSubfolders', true);
    untagged_tests =  suite.selectIf(~HasTag);
    tagged_tests =  suite.selectIf(HasTag);
    long_tests = tagged_tests.selectIf(HasTag('Long'))

    if all
        result = run(suite)
    else
        result = run(untagged_tests)
    end
end
