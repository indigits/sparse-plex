function [matching,optimal_cost]=hungarian(A, options)
%HUNGARIAN Solve the Assignment problem using the Hungarian method.
%
%[matching,optimal_cost]=hungarian(A, options)
%A - a square cost matrix.
%matching - the optimal assignment (from column to row)
%optimal_cost - the cost of the optimal assignment.
if nargin < 2
    options = struct;
end
if ~isfield(options, 'verbose')
    options.verbose = 0;
end
[matching,optimal_cost] = mex_hungarian(A, options.verbose);
end
