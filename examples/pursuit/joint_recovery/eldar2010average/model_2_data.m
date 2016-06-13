function X = model_2_data(N, K, S)
    % Data as per model 2 in eldar2010average paper
    gen  = spx.data.synthetic.SparseSignalGenerator(N, K, S);
    X = gen.complex_gaussian;
end


