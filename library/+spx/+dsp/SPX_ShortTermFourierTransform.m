classdef SPX_ShortTermFourierTransform < handle

properties(SetAccess=private)
    % Length of block
    BlockLength
    % Number of samples in overlaps
    OverlappedSamplesCount
    % FFT length
    FFTLength
    % Window type
    WindowType
    % Window 
    Window
end

methods
    function self  = SPX_ShortTermFourierTransform(...
        blockLength, overlappedSamples, fftLength, windowType)
        self.BlockLength  = blockLength;
        self.OverlappedSamplesCount = overlappedSamples;
        self.FFTLength = fftLength;
        self.WindowType = windowType;
        if strcmp(windowType, 'hamming')
            self.Window = hamming(blockLength)';
        elseif strcmp(windowType,'blackman')
            self.Window = blackman(blockLength)';
        else
            error('Unsupported window type');
        end
    end

    function [ spec, timePoints]  = run(self, signal)
        blockLength = self.BlockLength;
        overlappedSamples = self.OverlappedSamplesCount;
        N = length(signal);
        NBlocks = SPX_SP.overlapped_blocks_count(N, blockLength...
            , overlappedSamples);
        w = self.Window;
        shift = blockLength - overlappedSamples;
        fftLength = self.FFTLength;
        start = 0;
        for ii=1:NBlocks
            % Let's identify the start and end of the block
            range = start + (1:blockLength);
            % Let's read off the block and apply windowing
            x = signal(range) .* w;
            % Identify normalized start time for this block
            timePoints(ii) = start +1;
            % Compute fft of this 
            Xf  = fft(x, fftLength);
            spec(:, ii) = Xf;
            start = start + shift;
        end
    end
end


end
