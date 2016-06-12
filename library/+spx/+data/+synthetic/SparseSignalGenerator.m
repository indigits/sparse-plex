classdef SparseSignalGenerator < handle
    %SparseSignalGenerator creates sparse signals
    
    properties
        % The ambient signal dimension
        N 
        % The sparsity level
        K
        % Number of vectors to generate
        S
        % The resultant vectors
        X
        % The Sparse support
        Omega
    end
    
    methods
        function self = SparseSignalGenerator(N, K, S)
            self.N = N;
            self.K = K;
            if nargin < 3
                S = 1;
            end
            self.S = S;
            self.X = zeros(N, S);
            self.Omega = randperm(N, K);
        end
        
        function result = uniform(self, a,b)
            % Generates sparse signals from uniform distribution
            if nargin < 2
                a = 0; b =1;
            elseif nargin < 3
                % make the range to be [-a a]
                a = -a;
                b = -a;
            end
            if b <= a
                error('b must be larger than a');
            end
            self.X(self.Omega, :) =  a + (b-a).*rand(self.K,self.S);
            result = self.X;
        end
        
        function result = biUniform(self, a, b)
            % Generates sparse vectors where each non-zero values
            % is picked up uniformly from the ranges
            % [-b, -a] and [a, b]
            if nargin < 2
                a = 1; b =2;
            elseif nargin < 3
                b = 2*a;
            end
            if a < 0 || b < 0
                error('a and b both must be +ve');
            end
            if b <= a
                error('b must be larger than a');
            end
            % unsigned result
            x = a + (b-a).*rand(self.K,self.S);
            % sign
            sgn = sign(randn(self.K,self.S));
            % Final result
            self.X(self.Omega, :) = sgn .* x;
            result = self.X;
        end
        
        function result = gaussian(self)
            self.X(self.Omega, :) =  randn(self.K,self.S);
            result = self.X;
        end

        function result = complex_gaussian(self)
            real_part = randn(self.K,self.S);
            imag_part = randn(self.K,self.S);
            samples = real_part + i * imag_part;
            self.X(self.Omega, :) =  samples;
            result = self.X;
        end

        function result = real_spherical_rows(self)
            % Returns a multi-channel ensemble where each non-zero row is unit norm.

            % Generate Gaussian entries
            samples = randn(self.K,self.S);
            % Normalize the rows
            samples = spx.commons.norm.normalize_l2_rw(samples);
            self.X(self.Omega, :) = samples;
            result = self.X;
        end

        function result = complex_spherical_rows(self)
            %  Returns a multi-channel ensemble where each non-zero row is unit norm.
            % Generate Complex Gaussian entries
            real_part = randn(self.K,self.S);
            imag_part = randn(self.K,self.S);
            samples = real_part + i * imag_part;
            % Normalize the rows
            samples = spx.commons.norm.normalize_l2_rw(samples);
            self.X(self.Omega, :) = samples;
            result = self.X;
        end

        function result = rademacher(self)
            self.X(self.Omega, :) =  2*randi([0, 1], self.K,self.S)-1;
            result = self.X;
        end

        function result = biGaussian(self, offset, sigma)
            if nargin < 3
                sigma = 1;
            end
            if nargin < 2
                offset = 1;
            end
            % Generate Gaussian signals
            x = randn(self.K,self.S); 
            % Scale them
            x = sigma * x;
            % Now introduce offset
            x = x + offset*sign(x);
            self.X(self.Omega, :) = x;
            result = self.X;
        end
    end
    
end

