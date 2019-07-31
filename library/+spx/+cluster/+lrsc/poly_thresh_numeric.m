%--------------------------------------------------------------------------
% [A,C] = polythreshAP(D,tau,alpha)
% Low Rank Subspace Clustering algorithm for data lying in a union of 
% subspaces and contaminated with outliers
%
% min |C|_* + tau/2*|A-AC|_F^2 + alpha/2*|D-A|_F^2  s.t. C = C'
%
% C = affinity matrix
% A = clean data matrix whose columns are points in a union of subspaces
% D = data matrix whose columns are points in a union of subspaces
%         (without outliers)
% tau = scalar parameter 
% alpha = scalar parameter 
%--------------------------------------------------------------------------
% Copyright @ Paolo Favaro, January 2013
% Adapted for SPX: 2019
%--------------------------------------------------------------------------
function [A,C] = poly_thresh_numeric(D,tau,alpha)
% compute polynomial thresholding operator numerically
% notice that the singular values of A are always smaller
% than the singular values of D

% Compute the SVD of the data set
[U,S,V] = svd(D,'econ');
% Its singular values
sigma = diag(S);

% We will numerically minimize the cost function Phi(lambda, sigma)
% in eq 29
if max(sigma)>0
    % Create a mesh grid of lambda and sigma values
    lambdas = 0:max(sigma)/300:max(sigma);
    [lam,sig] = meshgrid(lambdas,sigma);
    % Compute the basic cost on each of the (x, y) pairs
    cost = alpha/2*(sig-lam).^2;
    % Identify the mesh grid points where lambda is greater than threshold
    I1 = lam>1/sqrt(tau);
    if tau>1e-6
        % adjust cost as per eq 29 (a upper)
        cost(I1) = cost(I1)+(1-1/2/tau*lam(I1).^-2);
    end
    % identify the mesh grid points where lambda is less than the threshold
    I2 = lam<=1/sqrt(tau);
    if tau<1e28
        % adjust cost as per eq 29 (b lower)
        cost(I2) = cost(I2)+tau/2*lam(I2).^2;
    end
    % Find the minimum of cost over sigmas
    [~,ind] = min(cost,[],2);
    % Pick the corresponding lambda values
    lambda = lambdas(ind);
else
    % Nothing to do
    lambda = sigma;
end
% Compute the cleaned dictionary
A = U*diag(lambda)*V';

if nargout>1
    % The rank of representation matrix
    n = sum(lambda>1/sqrt(tau));
    if n>0
        % Prepare the representation matrix
        C = V(:,1:n)*(eye(n)-1/tau*diag(1./lambda(1:n).^2))*V(:,1:n)';
    else
        % An all zeros representation matrix
        C = zeros(size(A,2));
    end
end

end