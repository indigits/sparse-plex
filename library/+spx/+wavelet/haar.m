classdef haar

methods(Static)

    function qmf = quad_mirror_filter()
        % Generates orthonormal quadrature mirror filter for Haar wavelet transform
        qmf = [1 1] ./ sqrt(2);
    end

    function wave = wavelet_function(j, k, n)
        % Makes an orthogonal wavelet function
        %
        % Inputs: 
        %  j, k - scale and location indices
        %  n - signal length (dyadic)
        qmf = spx.wavelet.haar.quad_mirror_filter();
        w = zeros(1, n);
        % identify the index of the j-th scale at k-th translation
        index = spx.wavelet.dyad_to_index(j, k);
        w(index) = 1;         
        wave = spx.wavelet.transform.inverse_periodized_orthogonal(qmf, w, j);
    end

    function wave = scaling_function(j, k, n)
        % Makes an orthogonal scaling function
        %
        % Inputs: 
        %  j, k - scale and location indices
        %  n - signal length (dyadic)
        qmf = spx.wavelet.haar.quad_mirror_filter();
        w = zeros(1, n);
        % k-th translate in the coarsest part of the wavelet coefficients
        w(k) = 1;
        wave = spx.wavelet.transform.inverse_periodized_orthogonal(qmf, w, j);
    end
end


end
