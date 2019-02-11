function y = shrinkage(a, kappa)
% Performs element wise shrinkage
    % y = max(0, a-kappa) - max(0, -a-kappa);
    y = max(0, a-kappa) + min(0, a+kappa);
end

