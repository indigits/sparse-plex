classdef SPX_Modulator < handle

    methods(Static)

        function [ outputSequence ] = modulate_bits_with_signals( inputSequence, s1, s0)
            %MODULATEBINARYSEQUENCE Modulates a sequence of bits to create output
            % The size of signal for each bit
            [N, L] = size(s1);
            % If s0 is not defined, we will assume s0 to be all zeros
            if ~exist('s0','var')
              s0=zeros(size(s1));
            end
            if ~iscolumn(s1)
                error('s1 must be a column vector.');
            end
            if ~iscolumn(s0)
                error('s0 must be a column vector.');
            end
            if ~isvector(inputSequence)
                error('inputSequence must be a vector.');
            end
            % Number of bits
            E = length(inputSequence);
            % Combine the two signals into a matrix
            s = [s0 s1];
            % The row number for each output
            r  = 1:N;
            outputSequence  = s(r, inputSequence+1);
            outputSequence = reshape(outputSequence, N*E,1);
        end

        function [ transmittedSequence ] = modulate_bits_with_gaussian_noise(...
            transmittedBits, N, sigma1, sigma0)
            %MODULATE_BITS_WITH_GAUSSIAN_NOISE Generates Gaussian noise samples with different
            %variances for the transmitted bits

            %   Detailed explanation goes here

            % Number of transmitted bits
            B = length(transmittedBits);
            % We create space for transmitted sequence
            transmittedSequence = zeros(B * N , 1);
            for i=1:B
                pos = (i-1)*N;
                bit = transmittedBits(i);
                if bit
                    transmittedSequence(pos + (1:N))  = sigma1 * randn(N,1);
                else
                    transmittedSequence(pos + (1:N))  = sigma0 * randn(N,1);
                end
            end

        end


    end

end
