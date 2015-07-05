classdef SPX_HaarWavelet

methods(Static)

    function qmf = on_qmf_filter()
        % Generates orthonormal quadrature mirror filter for Haar wavelet transform
        qmf = [1 1] ./ sqrt(2);
    end
end


end
