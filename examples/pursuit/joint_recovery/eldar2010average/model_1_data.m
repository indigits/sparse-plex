function X = model_1_data(N, K, S)
    % Data as per model 1 in eldar2010average paper
    gen  = spx.data.synthetic.SparseSignalGenerator(N, K, S);
    X = gen.gaussian;
    omega = gen.Omega;
    Phi = X(omega, :);    
    Sigma = diag(randn(K, 1));
    X(omega, :) = Sigma * Phi;
end


