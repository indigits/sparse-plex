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
