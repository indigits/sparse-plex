classdef baylkin

methods(Static)

    function qmf = quad_mirror_filter()
        % Generates orthonormal quadrature mirror filter for Haar wavelet transform
        qmf = [ .099305765374   .424215360813   .699825214057   ...
            .449718251149   -.110927598348  -.264497231446  ...
            .026900308804   .155538731877   -.017520746267  ...
            -.088543630623  .019679866044   .042916387274   ...
            -.017460408696  -.014365807969  .010040411845   ...
            .001484234782   -.002736031626  .000640485329   ];
    end

end


end
