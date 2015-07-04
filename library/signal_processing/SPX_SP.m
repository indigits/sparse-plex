classdef SPX_SP
% Basic functions related to signal processing

    methods(Static)
        function count = overlapped_blocks_count(...
            signalLength, blockLength, overlappedSamples )
            num = signalLength  - blockLength;
            den = blockLength - overlappedSamples;
            count = fix(num/den) + 1;
        end
        function locations = overlapped_blocks_locations(...
            signalLength, blockLength, overlappedSamples )
            num = signalLength  - blockLength;
            den = blockLength - overlappedSamples;
            count = SPX_SP.overlapped_blocks_count(signalLength, ...
                blockLength, overlappedSamples);
            locations = den * (1:count);
            locations = locations - (den -1);
        end
    end


end
