classdef SPX_NoiseGen
    %NOISEGENERATOR Generates noise
    
    properties
        % noise type as a string
        NoiseTypeStr
        % The ambient signal dimension
        N 
        % Number of vectors to generate
        S
        % The resultant vectors
        X
    end
    
    methods
        function self = SPX_NoiseGen(N , S, noiseType)
            if ~exist('N', 'var')
                N = 1024;
            end
            if ~exist('S', 'var')
                S = 1;
            end
            if ~exist('noiseType', 'var')
                noiseType = 'Gaussian';
            end
            self.NoiseTypeStr = noiseType;
            self.N = N;
            self.S = S;
            self.X = zeros(N, S);
        end
        
        function result = gaussian(self, sigma, mean)
            if ~exist('mean', 'var')
                mean = 0;
            end
            % Generates a gaussian noise at specific variance
            self.X = sigma  * randn(self.N, self.S) + mean;
            result = self.X;
        end
    end
    
    methods(Static)
        function noise = createNoise(signal, snrDb)
            snr = db2pow(snrDb);
            [m, n] = size(signal);
            noise = randn(m, n);
            % we treat each column as a separate data vector
            for i=1:n
                signalNorm = norm(signal(:,i));
                noiseNorm = norm(noise(:,i));
                actualNormRatio = signalNorm / noiseNorm;
                requiredNormRatio = sqrt(snr);
                factor = actualNormRatio  / requiredNormRatio;
                noise(:,i) = factor .* noise(:,i);
            end
        end

        function noises = createNoise2(signals, snrDb)
            row = false;
            if isrow(signals)
                row = true;
                signals = signals';
            end
            [signal_size, num_signals] = size(signals);
            noises = randn(signal_size, num_signals);
            signal_powers = sum(signals .^2) / signal_size;
            noise_powers = sum(noises .^2) / signal_size;
            scale_factors = (signal_powers./noise_powers)*10^(-snrDb/10);
            for s=1:num_signals
                noises(:, s) = sqrt(scale_factors(s)) * noises(:, s);
            end
            if row
                % restore row vector
                noises = noises';
            end
        end


        function noises = createNoise3(signals, snrDb)
            % See http://www.gaussianwaves.com/2015/06/how-to-generate-awgn-noise-in-matlaboctave-without-using-in-built-awgn-function/
            row = false;
            if isrow(signals)
                row = true;
                signals = signals';
            end
            [signal_size, num_signals] = size(signals);
            SNR = 10^(snrDb/10); %SNR to linear scale
            signal_powers = sum(abs(signals) .^2) / signal_size;
            noise_powers = signal_powers ./ SNR;
            noises = zeros(signal_size, num_signals);
            for s=1:num_signals
                N0 = noise_powers(s);
                if isreal(signals)
                    sigma = sqrt(N0);
                    noise = sigma * randn(signal_size, 1);
                else
                    sigma = sqrt(N0/2);
                    noise = sigma * ( randn(signal_size, 1) + 1i * randn(signal_size, 1));
                end
                noises(:, s) = noise;
            end
            if row
                % restore row vector
                noises = noises';
            end
        end


        function noises = createNoise4(signals, snrDb)
            row = false;
            if isrow(signals)
                row = true;
                signals = signals';
            end
            [signal_size, num_signals] = size(signals);
            SNR = 10^(snrDb/10); %SNR to linear scale
            signal_energies = sum(abs(signals) .^2);
            noise_powers = signal_energies ./ SNR;
            noises = zeros(signal_size, num_signals);
            for s=1:num_signals
                N0 = noise_powers(s);
                if isreal(signals)
                    sigma = sqrt(N0);
                    noise = sigma * randn(signal_size, 1);
                else
                    sigma = sqrt(N0/2);
                    noise = sigma * ( randn(signal_size, 1) + 1i * randn(signal_size, 1));
                end
                noises(:, s) = noise;
            end
            if row
                % restore row vector
                noises = noises';
            end
        end

    end
    
end

