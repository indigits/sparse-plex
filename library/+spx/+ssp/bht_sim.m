classdef bht_sim

    methods(Static)

        function [detectionResults] = constant_signal_with_gaussian_noise(...
            P1, C, sigma, B, N)
            %CONSTANT_SIGNAL_WITH_GAUSSIAN_NOISE Simulates a BHT problem to measure
            %performance.
            % P1 : prior probability of 1 bit.
            % C : Cost matrix : Cost of saying H_i given H_j. 
            % sigma: Gaussian noise standard deviation
            % B : Number of bits to be transmitted.
            % N : Number of times the bit is repeated in constant signal

            % If sigma is not defined, we will assume some sigma
            if ~exist('sigma','var')
              sigma=1;
            end
            % If B is not defined, we will assume some B
            if ~exist('B','var')
                % Number of bits being transmitted
                B = 1000*10;
            end
            % If N is not defined, we will assume some N
            if ~exist('N','var')
                % Number of samples per detection test.
                N = 10;
            end
            % The signal shape
            m = 1;
            signal = m * ones(N, 1);
            % We create Transmitted bits using Bernoulli distribution
            transmittedBits =  binornd(1, P1, B, 1);
            % We compute the transmitted sequence
            transmittedSequence = SPX_Modulator.modulate_bits_with_signals(transmittedBits, signal);
            % We create transmission channel noise
            noise = sigma * randn(size(transmittedSequence));
            % We add noise to transmitted data to create received sequence
            receivedSequence = transmittedSequence + noise;
            % We compute the suffficient statistic for this
            statistic = SPX_Statistics.compute_statistic_per_vector(receivedSequence, N, @sum);
            % The threshold for LRT
            eta = SPX_BinaryHypothesisTest.bayes_criterion_threshold(C, P1);
            gamma = (sigma^2 / m) * log (eta) + (N *m)/ 2;
            % We create the received bits 
            receivedBits = statistic >= gamma;
            % We compute detection results
            detectionResults = SPX_BinaryHypothesisTest.performance(...
                transmittedBits, receivedBits);
        end


    end

end
