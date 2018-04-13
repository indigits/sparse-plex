function z =  fast_omp_ar_solver(Phi, K, y)
    % Let's get the corresponding matrix
    Phi = double(Phi);
    options.threshold_factor = 2;
    options.reset_cycle = 4;
    options.verbose = 0;
    res_norm_thr = 1e-3;
    % Solve the sparse recovery problem using OMP
    z = spx.fast.omp_ar(Phi, y, K, res_norm_thr, options);
end