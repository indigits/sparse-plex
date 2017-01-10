classdef SPX_DDRefinement
% Provides functions which implement the Deslauriers-Dubuc refinement scheme
%
%
%  Reference: "Interpolating Wavelet Transforms" by Donoho

methods(Static)

    function [left_pred, right_pred] = create_edge_filter(D)
        if ~spx.discrete.number.is_odd_natural(D) | D < 3
            error('D must be an odd number greater than 2.');
        end
        % Divide D by half
        d_half  = floor(D/2);
        % Compute moment matrix
        moment_matrix = zeros(D + 1, D+1);
        for k = 1:(D+1)
            for l = 0:D
                moment_matrix(l + 1, k) = l^(k - 1);
            end
        end        
        % Compute the inverse of moment matrix
        inverse_moment_matrix = inv(moment_matrix);
        % Compute the left imputation matrix
        left_imputation_matrix = zeros(D - 1, D + 1);
        for col=1:D+1
            for row=1:D-1
                left_imputation_matrix(row, col) = ((row -1)/2)^(col -1); 
            end
        end
        % Compute the left prediction matrix
        left_pred = left_imputation_matrix * inverse_moment_matrix;

        % Compute the right imputation matrix
        right_imputation_matrix = zeros(D - 1, D + 1);
        for col=1:D+1
            for row=1:D-1
                right_imputation_matrix(row, col) = ((row -2)/2)^(col -1); 
            end
        end
        % Compute the right prediction matrix
        right_pred = right_imputation_matrix * inverse_moment_matrix;
    end

    function filter = create_filter(D)
        % Creates a filter for Deslauriers-Dubuc refinement
        % 
        % Inputs:  
        %  D - Degree of polynomial for interpolation
        % 
        % 
        if ~spx.discrete.number.is_odd_natural(D)
            error('D must be an odd number.');
        end
        % Divide D by half
        d_half  = floor(D/2);
        % Compute moment matrix
        moment_matrix = zeros(D + 1, D+1);
        for k = 0:D
            for l = -d_half:(d_half+1)
                moment_matrix(l + d_half + 1, k + 1) = l^k;
            end
        end
        % Compute the inverse of moment matrix
        inverse_moment_matrix = inv(moment_matrix);
        % Compute the imputation matrix
        imputation_matrix = zeros(2, D + 1);
        for k = 0:D
            imputation_matrix(1, k+1) = 0. .^k;
            imputation_matrix(2, k+1) = .5 .^k;
        end
        % Compose for prediction matrix
        prediction_matrix = imputation_matrix * inverse_moment_matrix;
        % Interchange rows of prediction matrix
        prediction_matrix = prediction_matrix(2:-1:1, :);
        % Prepare the filter
        filter = prediction_matrix(:);
    end

    function x_refined = refine(x_coarse, D, refinement_filter, left_pred, right_pred)
        % Creates a refinement of x using Deslauriers-Dubuc refinement scheme
        % 
        % Inputs: 
        % D - degree of polynomials used for interpolation
        %
        % The odd samples at location 2*i -1 in the x_refined agree with the
        % samples i in x_coarse.
        % The even samples at 2*i in x_refined are obtained by polynomial interpolation
        % of the coarse neighboring samples near i.

        % Construct the refinement filter if necessary
        % It should usually be precomputed to save time.
        if nargin < 3
            refinement_filter = SPX_DDRefinement.create_filter(D);
        end
        if nargin < 4 & D > 1
            [left_pred, right_pred] = SPX_DDRefinement.create_edge_filter(D);
        end
        n = length(x_coarse);
        n2 = 2*n;
        % Ensure that x_coarse is a row vector
        col = iscolumn(x_coarse);
        if col
            x_coarse = x_coarse';
        end
        % We can do rest of the process in row vectors.
        % Allocate space for the refinement
        x_refined =  zeros(1, n2);

        % Intersperse x_coarse with zeros
        x = SPX_Wavelet.up_sample(x_coarse);

        % Filter it with the refinement filter
        tmp = conv(refinement_filter, x);
        % Copy the middle portion of the signal safely.
        x_refined((D):(n2 - D + 1)) = tmp((2*D):(n2+1));
        % We are copying 2*n+1 - 2*D + 1 = 2 n - 2 (D -1 )   samples from tmp.
        % We are leaving out the first D-1 samples and last D-1 samples in x_refined.
        % If D =1 , then nothing else needs to be done.
        % Otherwise, we perform boundary correction
        if D > 1
            % Perform boundary correction
            % TODO complete this
            x_refined(1:(D-1))  = left_pred * x(1:(D+1))';
            xr = spx.commons.vector.reverse(x(n-D:n));
            x_refined(n2 - D + 2:n2)  =  spx.commons.vector.reverse(right_pred * xr');
        end

        % Ensure that the refinement has the same shape as the coarse vector
        if col
            x_refined = x_refined';
        end
    end

end

end
