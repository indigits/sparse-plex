Synthetic Signals
==============================

.. highlight:: matlab


Some easy to setup recovery problems
------------------------------------------------------

General approach::

    m = 64;
    n = 121;
    k = 4;
    dict = spx.dict.simple.gaussian_dict(m, n);
    gen = spx.data.synthetic.SparseSignalGenerator(n, k);
    % create a sparse vector
    rep =  gen.biGaussian();
    signal = dict*rep;
    problem.dictionary = dict;
    problem.representation_vector = rep;
    problem.sparsity_level = k;
    problem.signal_vector = signal;


The problems::

    problem = spx.data.synthetic.recovery_problems.problem_small_1()    
    problem = spx.data.synthetic.recovery_problems.problem_large_1()    
    problem = spx.data.synthetic.recovery_problems.problem_barbara_blocks()    


Sparse signal generation
-------------------------------

Create generator::

    N = 256; K = 4; S = 10;
    gen  = spx.data.synthetic.SparseSignalGenerator(N, K, S);

Uniform signals::

    result = gen.uniform();
    result = gen.uniform(1, 2);
    result = gen.uniform(-1, 1);


Bi-uniform signals::

    result = gen.biUniform();
    result = gen.biUniform(1, 2);


Gaussian signals::

    result = gen.gaussian();


BiGuassian signals::

    result = gen.biGaussian();
    result = gen.biGaussian(2.0);
    result = gen.biGaussian(10.0, 1.0);



Compressible signal generation
------------------------------------------------

We can use ``randcs`` function by *Cevher, V.*
for constructing compressible signals::

    N = 100;
    q = 1;
    x = randcs(N, q);
    plot(x);
    plot(randcs(100, .9));
    plot(randcs(100, .8));
    plot(randcs(100, .7));
    plot(randcs(100, .6));
    plot(randcs(100, .5));
    plot(randcs(100, .4));
    lambda = 2;
    x = randcs(N, q, lambda);
    dist = 'logn';
    x = randcs(N, q, lambda, dist);



Multi-subspace signal generation
----------------------------------------------

Signals with disjoint supports::

    % Dimension of representation space
    N = 80;
    % Number of subspaces
    P = 8;
    % Number of signals per subspace
    SS = 10;
    % Sparsity level of each signal (subspace dimension)
    K = 4;
    % Create signal generator
    sg = spx.data.synthetic.MultiSubspaceSignalGenerator(N, K);
    % Create disjoint supports
    sg.createDisjointSupports(P);
    sg.setNumSignalsPerSubspace(SS);
    % Generate  signal representations
    sg.biUniform(1, 4);
    % Access  signal representations
    X = sg.X;
    % Corresponding supports
    qs = sg.Supports;
