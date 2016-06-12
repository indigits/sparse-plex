classdef simple < handle
    %simple Creates basic dictionaries
    properties
    end
    
    methods(Static)
        
        function result = dirac_fourier_mtx(N)
            % Constructs a Dirac Fourier two-ortho basis
            result = [eye(N) dftmtx(N)' ./ sqrt(N) ];
        end

        function result = dirac_fourier_dict(N)
            % Constructs a Dirac Fourier two-ortho basis
            result = [eye(N) dftmtx(N)' ./ sqrt(N) ];
            % Wrap it into a Matrix operator
            result = spx.dict.MatrixOperator(result);
        end

        function result = dirac_dct_mtx(N)
            % Constructs a Dirac DCT two-ortho basis
            result = [eye(N) dctmtx(N)' ];
        end

        function result = dirac_dct_dict(N)
            % Constructs a Dirac DCT two-ortho basis
            result = [eye(N) dctmtx(N)' ];
            % Wrap it into a Matrix operator
            result = spx.dict.MatrixOperator(result);
        end

        function result = dirac_hadamard_mtx(N)
            % Constructs a Dirac Hadamard two-ortho basis
            H = hadamard(N);
            H = 1/sqrt(N)  * H;
            result = [eye(N) H ];
        end

        function result = dirac_hadamard_dict(N)
            % Constructs a Dirac Hadamard two-ortho basis
            result = spx.dict.simple.dirac_hadamard_mtx(N);
            % Wrap it into a Matrix operator
            result = spx.dict.MatrixOperator(result);
        end

        function result = gaussian_mtx(N, D, normalized_columns)
            % Constructs a Gaussian dictionary with normalized columns
            if nargin < 3
                % By default columns will be normalized
                normalized_columns = true;
            end

            % Gaussian Random Number Generator
            result = randn(N, D);
            if normalized_columns
                % Normalized each column
                result = spx.commons.norm.normalize_l2(result); 
            else
                % Make sure that variance of individual entries is 1/N
                result = result ./ sqrt(N);
            end
        end

        function result = gaussian_dict(N, D, normalized_columns)
            if nargin < 3
                % By default columns will be normalized
                normalized_columns = true;
            end
            result = spx.dict.simple.gaussian_mtx(N, D, normalized_columns);
            % Wrap it into a Matrix operator
            result = spx.dict.MatrixOperator(result);
        end

        function result = rademacher_mtx(M, N)
        %RADEMACHER_MTX Constructs a simple rademacher sensing matrix
        % result: The constructed sensing matrix
            % We will create the measurement matrix using 
            % Uniform discrete Random Number Generator
            result = 2*randi([0, 1], M, N)-1;
            % Make sure that variance is 1/M
            result = result ./ sqrt(M);
        end

        function result = rademacher_dict(M, N)
            %RADEMACHER_DICT Constructs a Rademacher random dictionary
            result = spx.dict.simple.rademacher_mtx(M, N);
            % Wrap it into a Matrix operator
            result = spx.dict.MatrixOperator(result);
        end

        function result = partial_fourier_mtx( M,N )
            %PARTIAL_FOURIER_MTX Constructs a partial Fourier matrix

            % We first construct an NxN DFT matrix
            dftMatrix  =   dftmtx(N);
            % We now select M rows randomly
            rows = randperm(N, M);
            % Also we need to scale the matrix Phi for norm preservation
            result = (1/sqrt(M)).* dftMatrix(rows, :);
        end

        function result = partial_fourier_dict( M, N)
            result = spx.dict.simple.partial_fourier_mtx(M, N);
            % Wrap it into a Matrix operator
            result = spx.dict.MatrixOperator(result);
        end

        function result = overcomplete1DDCT(N, D)
            if D < N
                error('D must be greater than or equal to N');
            end
            DCT=zeros(N,D);
            for k=0:1:D-1,
                is = 0:1:N-1;
                % Create one column
                col=cos(is'*k*pi/D);
                if k>0
                    col=col-mean(col); 
                end;
                DCT(:,k+1)=col/norm(col);
            end;
            % Wrap it into a Matrix operator
            result = spx.dict.MatrixOperator(DCT);
        end

        function result = overcomplete2DDCT(N, D)
            if D < N
                error('D must be greater than or equal to N');
            end
            dr = sqrt(D);
            if dr ~= floor(dr)
                error('D must be square of an integer');
            end
            nr = sqrt(N);
            if nr ~= floor(nr)
                error('N must be square of an integer');
            end
            dr = floor(dr);
            nr = floor(nr); 
            % Let us construct a 1D-DCT matrix of size 8x11.
            DCT = spx.dict.simple.overcomplete1DDCT(nr, dr);
            DCT = DCT.A;
            Dictionary = kron(DCT, DCT);
            % Wrap it into a Matrix operator
            result = spx.dict.MatrixOperator(Dictionary);
        end

        function result = spie_2011(name)
            switch name
                case 'ahoc'
                    fname = 'dict_ahoc.mat';
                case 'data'
                    fname = 'dict_data.mat';
                case 'orth'
                    fname = 'dict_orth.mat';
                case 'rand'
                    fname = 'dict_rand.mat';
                case 'sine'
                    fname = 'dict_sine.mat';
                case 'rlsdla'
                    fname ='ex414_Jun250624.mat';
                otherwise
                    error('Unsupported dictionary');
            end
            % path of this file
            fpath = mfilename('fullpath');
            % path of this directory
            fpath = fileparts(fpath);
            % path of SPIE2011 directory
            fpath = fullfile(fpath, 'spie2011');
            % path of dictionary file
            fpath = fullfile(fpath, fname);
            file = load(fpath);
            if isfield(file, 'D')
                dict = file.D;
            elseif isfield(file, 'res')
                dict = file.res.D;
            end
            % Wrap it into a Matrix operator
            result = spx.dict.MatrixOperator(dict);
        end
    end
    
end

