function result = ssc_mc_omp(X, D, K, params)
    if nargin < 4
        params.BranchingFactor = 2;
        params.MaxCandidatesToRetain = 4;
    end
    solver = spx.cluster.ssc.SSC_MC_OMP(X, D, K);
    solver.BranchingFactor = params.BranchingFactor;
    solver.MaxCandidatesToRetain = params.MaxCandidatesToRetain;
    fprintf('candidates: %d, bf: ', solver.MaxCandidatesToRetain);
    fprintf('%d ', solver.BranchingFactor);
    fprintf('\n');
    result = solver.solve();
end

% solver.MaxCandidatesToRetain = 4;
% if K <= 5
%     solver.BranchingFactor = [2 1 1 1 1];
% else if K <= 30
%     solver.BranchingFactor = [4 2 1 1 1];
% else
%     solver.BranchingFactor = [8 4 2 1 1];
%     solver.MaxCandidatesToRetain = 8;
% end
