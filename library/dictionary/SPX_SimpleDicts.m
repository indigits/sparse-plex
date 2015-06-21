classdef SPX_SimpleDicts < handle
    %CS_BASICDICTIONARYCREATOR Creates basic dictionaries
    properties
    end
    
    methods(Static)
        function result = DiracFourier(N)
            % Constructs a Dirac Fourier two-ortho basis
            result = [eye(N) dftmtx(N)' ./ sqrt(N) ];
            % Wrap it into a Matrix operator
            result = SPX_MatrixOperator(result);
        end
        function result = DiracDCT(N)
            % Constructs a Dirac DCT two-ortho basis
            result = [eye(N) dctmtx(N)' ];
            % Wrap it into a Matrix operator
            result = SPX_MatrixOperator(result);
        end

        function result = Gaussian(N, D, normalized_columns)
            % Constructs a Gaussian dictionary with normalized columns
            if nargin < 3
                % By default columns will be normalized
                normalized_columns = true;
            end

            % Gaussian Random Number Generator
            result = randn(N, D);
            if normalized_columns
                % Normalized each column
                result = SPX_Norm.normalize_l2(result); 
            else
                % Make sure that variance of individual entries is 1/N
                result = result ./ sqrt(N);
            end
            % Wrap it into a Matrix operator
            result = SPX_MatrixOperator(result);
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
            result = SPX_MatrixOperator(DCT);
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
            DCT = SPX_SimpleDicts.overcomplete1DDCT(nr, dr);
            DCT = DCT.A;
            Dictionary = kron(DCT, DCT);
            % Wrap it into a Matrix operator
            result = SPX_MatrixOperator(Dictionary);
        end

        function result = SPIE2011(name)
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
            result = SPX_MatrixOperator(dict);
        end
    end
    
end

