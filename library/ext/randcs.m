function x = randcs(N, q, lambda, dist)
% RANDSC    Generate compressible signals from a specified distribution.
%---
% USAGE  x = randcs(N, q, lambda, dist)
%
%           N               : signal length
%           q               : compressibility of the signal
%
%           [Magnitudes of the generated signal coefficients, when sorted
%           in decreasing order, has an expected power-law decay rate of
%           1/q. When q is in (0 1], the signal is considered compressible.
%           Negative q input uses the default value:
%
%           (default)       q=1                                           ]
%
%           lambda          : positive scaling parameter
%
%           (default)       lambda=1
%
%           dist            : signal distribution
%
%           [Options
%           (default)       't'         Student's t
%                           'gpd'       generalized Pareto
%                           'logn'      log-normal
%                           'ev'        extreme value (Frechet)
%                           'logl'      log-logistic
%                           -distributions with forced compressibility-
%                           'ggd'       generalized Gaussian
%                           'wbl'       Weibull
%                           'gam'       gamma                             ]
%
%   Output vector x is a (1 x N)-dimensional compressible signal
%   realization from the specified distribution.
%
%   When q and lambda are (M x 1) vectors, x is an (M x N) matrix whose
%   i-th row corresponds to the compressible signal realization from
%   (q(i),lambda(i))-pair. When one of q and lambda is a scalar, it is
%   replicated M times.
%
%     -see
%
%      @inproceedings{cevherNIPS09,
%       author = "Cevher, V.",
%       title = "Learning with compressible priors",
%       booktitle = "NIPS",
%       address= "Vancouver, B.C., Canada",
%       year = "7--9 December 2009",}
%
%--------------------------------------------------------------------
% 9/20/2009, by Volkan Cevher. volkan@rice.edu. ver.1.0. For FUN. -RiceU.
%--------------------------------------------------------------------
% NOTES:
%       1. Distribution definitions can be found in cite{cevherNIPS09}.
%       2. Negative input values forces default parameters.
%       3. The distributions 'ggd', 'wbl', and 'gam' lose their
%       compressibility as the dimensions grow. RANDCS automatically
%       adjusts the distribution paramters to provide the desired decay for
%       the specified dimension; see \cite{cevherNIPS09}.
%
%--------------------------------------------------------------------

%--- input check
if nargin>4, error('Incorrect number of inputs!!!'), end
if nargin==0; N=1; else N= round(max(N,1)); end
if nargin==1; q= 1; lambda= 1; dist= 't'; end
if nargin==2;
    q= q(:); M= length(q); q(q<=0)=1; lambda= ones(M,1); dist= 't';
end;
if nargin>=3;
    q= q(:); Mq= length(q); q(q<=0)=1;
    lambda= lambda(:); Ml= length(lambda); lambda(lambda<=0)=1;
    if Ml==1
        M= Mq; lambda= lambda*ones(M,1);
    elseif Mq==1
        M= Ml; q= q*ones(M,1);
    elseif Ml==Mq
        M= Ml;
    else
        error('Dimension mismatch between q and lambda!!!')
    end
    if nargin==3,
        dist= 't';
    elseif ischar(dist)
        distNames = {'t','gpd','logn','ev','logl','ggd','wbl','gam'};
        i = strmatch(lower(dist), distNames);
        if numel(i) > 1
            error('Ambiguous distribution name: ''%s''.',dist);
        elseif numel(i) == 1
            dist = distNames{i};
        else
            error('The dist argument must be a distribution name.');
        end
    else
        error('The dist argument must be a distribution name.');
    end
end
%--- end of input check

%--- main
switch dist
    case 't'
        qq= q*ones(1,N);
        ll= lambda*ones(1,N);
        x= random('t',qq).*sqrt(ll./qq);
    case 'gpd'
        qq= q*ones(1,N);
        ll= lambda*ones(1,N);
        x= sign(rand(M,N)-1/2).*ll.*((rand(M,N).^(-1./qq))-1);
    case 'logn'
        qq= q*ones(1,N);
        ll= lambda*ones(1,N);
        x= random('logn',zeros(M,N),sqrt(2*log(N+1))./qq).*ll;
    case 'ev'
        qq= q*ones(1,N);
        ll= lambda*ones(1,N);
        x= ll.*((-log(rand(M,N))).^(-1./qq));
    case 'logl'
        qq= q*ones(1,N);
        ll= lambda*ones(1,N);
        x= ll.*((rand(M,N)).^(-1./qq));
    case 'ggd'
        disp('Forcing the GGD decay')
        qq= N*exp(lambertw(-1,-q/N));
        disp(['Your input(s)   q= [ ' num2str(q(1:min(3,M))',4) ' ...'])
        disp(['GGD exponent(s) p= [ ' num2str(qq(1:min(3,M))',4) ' ... '])
        ss= lambda.*sqrt(gamma(1./qq)./gamma(3./qq));
        if any(ss==0)
            disp('q<.2 presents numerical issues since gamma(3/p)->Inf!!!')
            disp('Corresponding output(s) will be zero...')
        end
        shape= (1./qq)*ones(1,N);
        scale= (ss.^qq)*ones(1,N);
        x= sign(rand(M,N)-1/2).*random('gam',shape,scale).^shape;
    case 'wbl'
        disp('Forcing the Weibull decay')
        qq= q/log(N);
        disp(['Your input(s)   q= [ ' num2str(q(1:min(3,M))',4) ' ...'])
        disp(['GGD exponent(s) p= [ ' num2str(qq(1:min(3,M))',4) ' ... '])
        ll= lambda*ones(1,N);
        x= random('wbl',ll,qq);
    case 'gam'
        disp('Forcing the gamma decay')
        qq= exp(q)/(N+1);
        disp(['Your input(s)   q= [ ' num2str(q(1:min(3,M))',4) ' ...'])
        disp(['GGD exponent(s) p= [ ' num2str(qq(1:min(3,M))',4) ' ... '])
        x= random('gam',qq*ones(1,N),lambda*ones(1,N));
end


