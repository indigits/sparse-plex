classdef SPX_CompressiveDetector < handle

    properties
    end

    properties(SetAccess=private)
        % The sensing matrix
        Phi
        % The signal to be detected
        Signal
        % Expected false alarm rate
        ExpectedPF
        % Statistic vector
        StatisticVector
        % Detection threshold
        Threshold
        % Norm of the projection of the signal 
        SignalProjectionNorm
    end

    methods 
        function self  = SPX_CompressiveDetector(phi, signal, sigma, expectedPF)
            self.Phi  = phi;
            self.Signal = signal;
            self.ExpectedPF = expectedPF;
            % Dimensions of the signal and measurement spaces
            [~, N] = size(phi);

            % Several precomputations

            % We find the projection operator for the row space of phi
            phiphiInv = pinv(phi *phi'); % MxM
            projPhi = phi' * phiphiInv * phi; % N x N

            % We compute the projection of s on phi
            sPhiProj  = projPhi * signal; % N x 1

            % We compute the norm of projection
            normSPhiProj = norm(sPhiProj); % should be less than 1
            self.SignalProjectionNorm = normSPhiProj;

            % We compute the vector which will be used to compute the sufficient
            % statistic
            sStatistic = phiphiInv * phi * signal;
            self.StatisticVector = sStatistic;


            % The threshold for NP criterion
            gamma = sigma * normSPhiProj * SPX_Prob.q_inv_function(expectedPF);
            self.Threshold = gamma;
        end

        function [receivedBits, measurementVectors, statistic] = solve(self, receivedSequence)
            phi = self.Phi;
            N = size(phi, 2);
            NN = round(numel(receivedSequence) / N);
            % Dimensionality reduction
            receivedSequenceVectors = reshape(receivedSequence, N, NN);
            measurementVectors = phi * receivedSequenceVectors; % MxNN
            % We compute the sufficient statistic for each measurement
            statistic = (self.StatisticVector' * measurementVectors)'; % Bx1
            % We create the received bits 
            receivedBits = statistic >= self.Threshold; % Bx1
        end
    end

    methods (Static)

        function [results] = simulate(...
            phi, signal, P1, sigma, expectedPF, B)

            solver = SPX_CompressiveDetector(phi, signal, sigma, expectedPF);

            % We return some of the numbers for use in caller
            results.gamma = solver.Threshold;
            normSPhiProj = solver.SignalProjectionNorm;
            expectedPD = SPX_Prob.q_function( (results.gamma  - normSPhiProj^2) / (sigma * normSPhiProj));
            results.expectedPD  = expectedPD;

            % We run simulation on NN bits per cycle
            NN = 1000;
            cycles = round(B/NN);
            detectionResults = 0;
            for i=1:cycles    
                %% Execution of transmission and detection 
                % We create Transmitted bits using Bernoulli distribution
                transmittedBits =  binornd(1, P1, NN, 1);
                % We compute the transmitted sequence
                transmittedSequence = SPX_Modulator.modulate_bits_with_signals(transmittedBits, signal);
                % We create transmission channel noise
                noise = sigma * randn(size(transmittedSequence));
                % We add noise to transmitted data to create received sequence
                receivedSequence = transmittedSequence + noise;
                [receivedBits, measurementVectors, statistic] = solver.solve(receivedSequence);
                % We compute detection results
                detectionResults = SPX_BinaryHypothesisTest.performance(...
                    transmittedBits, receivedBits, detectionResults);
                % Indicate how many bits have been simulated so far.
                disp(i*NN);
            end
            % We capture some data from last cycle for display
            results.transmittedBits = transmittedBits;
            results.transmittedSequence = transmittedSequence;
            results.receivedSequence = receivedSequence;
            results.measurementVectors = measurementVectors;
            results.statistic = statistic;
            results.receivedBits = receivedBits;
            % Overall detection results
            results.detectionResults = detectionResults;

        end

    end


end

