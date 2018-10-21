classdef SPX_WLShrinkage
% Provides methods for implementing wavelet shrinkage based algorithms


methods(Static)

        function w_thresholded = visu_shrink_thresholding(w, sigma)
            % Performs thresholding on wavelet coefficients as per VisuShrink algorithm
            % Typical steps are
            % Compute the wavelet transform
            % Call this function to perform soft thresholding and shrinkage
            % Compute inverse wavelet transform
            n = length(w);
            threshold = sqrt (2 * log(n)) * sigma / sqrt(n);
            w_abs = abs(w);
            diffs = w_abs - threshold;
            % identify the places where wavelet coefficients are below threshold
            neg_indices = diffs < 0;
            % Set them to 0
            diffs(neg_indices) = 0;
            % compute thresholded coefficients by preserving original sign
            w_thresholded = sign(w) .* diffs;

        end

end


end
