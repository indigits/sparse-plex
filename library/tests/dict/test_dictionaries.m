function tests = test_dictionaries
  tests = functiontests(localfunctions);
end

function test_gaussian(testCase)
    D = 10;
    N = 4;
    Dict = spx.dict.simple.gaussian_dict(N, D);
    verifyTrue(testCase, isa(Dict, 'spx.dict.MatrixOperator'));
    verifyTrue(testCase, isa(Dict, 'spx.dict.Operator'));
    % Check size
    [m, n] = size(Dict);
    verifyEqual(testCase, [m, n], [N, D]);
    % Validate that norms of each column are unity
    for d=1:D
        % Extract the column
        dd = Dict.column(d);
        assertElementsAlmostEqual(norm(dd), 1);
    end

end


function test_dirac_fourier(testCase)
    N = 16;
    Dict = spx.dict.simple.dirac_fourier_dict(N);
    sz = size(Dict);
    verifyEqual(testCase, sz, [N, 2*N]);
    % Validate that norms of each column are unity
    for d=1:2*N
        % Extract the column
        dd = Dict.column(d);
        assertElementsAlmostEqual(norm(dd), 1);
    end
end
