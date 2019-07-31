%--------------------------------------------------------------------------
% [A,C] = poly_thresh_closed_form(D,tau,alpha)
% Low Rank Subspace Clustering algorithm for data lying in a union of 
% subspaces and contaminated with outliers
%
% min |C|_* + tau/2*|A-AC|_F^2 + alpha/2*|Delta-A|_F^2  s.t. C = C'
%
% C = affinity matrix
% A = clean data matrix whose columns are points in a union of subspaces
% Delta = data matrix whose columns are points in a union of subspaces
%         (without outliers)
% tau = scalar parameter 
% alpha = scalar parameter 
%--------------------------------------------------------------------------
% Copyright @ Rene' Vidal
% Edited by Paolo Favaro, January 2013
% Adapted for SPX needs
%--------------------------------------------------------------------------
function [A,C] = poly_thresh_closed_form(D,tau,alpha)
% compute polynomial thresholding operator by using
% an approximate closed form formula
    % Size of dataset
    [Dx,Dy] = size(D);
    % Compute the full SVD of the dataset
    [U,S,V] = svd(D);
    % Compute the sigma star as per equations 33-35
    if (3*tau < alpha)
        % equation 33
        sigma = (alpha + tau)/alpha/sqrt(tau);
    else
        % inequality 35
        sigma = sqrt((alpha + tau)/alpha^2/tau);
        sigma = sqrt((alpha + tau)/alpha/tau + sqrt(sigma));
    end
    % Pick the singular values
    s = diag(S);
    % Perform closed form thresholding of singular values per eq 31 and 37
    % for s > sigma, we use eq 37
    % for s <= sigma, we use eq 31
    lambda = s .* (s > sigma) + alpha/(alpha+tau) * s.*(s <=sigma);
    % zero fill the singular values
    if Dx > Dy
        Lambda = [diag(lambda); zeros(Dx-Dy,Dy)];
    else
        Lambda = [diag(lambda) zeros(Dx,Dy-Dx)];
    end
    % Rank for C computation as per eq 21
    r = max(sum(lambda > 1/sqrt(tau)),1);
    % Compute the clean data dictionary
    A = U*Lambda*V';
    % Compute the representation matrix
    S2 = eye(r) - diag(1./(lambda(1:r).^2)/tau);
    C = V(:,1:r) * S2 * V(:,1:r)';
end
