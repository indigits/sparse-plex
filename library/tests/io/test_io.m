function tests = test_io
  tests = functiontests(localfunctions);
end

function test_bytes2str(testCase)
    import spx.io;
    verifyEqual (testCase, io.bytes2str(10), '10 Bytes');
    verifyEqual (testCase, io.bytes2str(1024), '1.00 KB');
    verifyEqual (testCase, io.bytes2str(1024*1024), '1.00 MB');
    verifyEqual (testCase, io.bytes2str(1024*1024*1024), '1.00 GB');
    verifyEqual (testCase, io.bytes2str(1024*1024*1024*1024), '1.00 TB');
    verifyEqual (testCase, io.bytes2str(2985984), '2.85 MB');
end


function test_flags(testCase)
    import spx.io.*;
    verifyEqual(testCase, yes_no(1), 'Yes');
    verifyEqual(testCase, true_false(1), 'true');
    verifyEqual(testCase, true_false_short(1), 'T');
    verifyEqual(testCase, success_failure(1), 'Success');
    verifyEqual(testCase, success_failure_short(1), 'S');
    verifyEqual(testCase, yes_no(0), 'No');
    verifyEqual(testCase, true_false(0), 'false');
    verifyEqual(testCase, true_false_short(0), 'F');
    verifyEqual(testCase, success_failure(0), 'Failure');
    verifyEqual(testCase, success_failure_short(0), 'F');

end