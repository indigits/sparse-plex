function z =  ar_solver(Phi, K, y)
    % Let's get the corresponding matrix
    Phi = double(Phi);
    result = atom_ranked_omp(Phi, y, K);
    z = result.z;
end