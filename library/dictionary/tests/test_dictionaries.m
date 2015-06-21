function test_suite = test_dictionaries
  initTestSuite;
end

function test_gaussian
    D = 10;
    N = 4;
    Dict = SPX_SimpleDicts.Gaussian(N, D);
    assertTrue(isa(Dict, 'SPX_MatrixOperator'));
    assertTrue(isa(Dict, 'SPX_Operator'));
    % Check size
    [m, n] = size(Dict);
    assertEqual([m, n], [N, D]);
    % Validate that norms of each column are unity
    for d=1:D
        % Extract the column
        dd = Dict.column(d);
        assertElementsAlmostEqual(norm(dd), 1);
    end

end


function test_dirac_fourier
    N = 16;
    Dict = SPX_SimpleDicts.DiracFourier(N);
    sz = size(Dict);
    assertEqual(sz, [N, 2*N]);
    % Validate that norms of each column are unity
    for d=1:2*N
        % Extract the column
        dd = Dict.column(d);
        assertElementsAlmostEqual(norm(dd), 1);
    end
end
