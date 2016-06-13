function X = model_3_data(N, K, S)
    % Data as per model 3 in eldar2010average paper
    gen  = spx.data.synthetic.SparseSignalGenerator(N, K, S);
    X = gen.complex_spherical_rows;
end


