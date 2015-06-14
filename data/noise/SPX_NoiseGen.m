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
    end
    
end

