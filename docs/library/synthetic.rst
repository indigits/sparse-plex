Synthetic Signals
==============================

.. highlight:: matlab


Some easy to setup recovery problems
------------------------------------------------------

General approach::

    m = 64;
    n = 121;
    k = 4;
    dict = CS_BasicDictionaryCreator.Gaussian(m, n);
    gen = CS_SparseSignalGenerator(n, k);
    % create a sparse vector
    rep =  gen.biGaussian();
    signal = dict*rep;
    problem.dictionary = dict;
    problem.representation_vector = rep;
    problem.sparsity_level = k;
    problem.signal_vector = signal;


The problems::

    problem = CS_RecoveryProblems.problem_small_1()    
    problem = CS_RecoveryProblems.problem_large_1()    
    problem = CS_RecoveryProblems.problem_barbara_blocks()    


Sparse signal generation
-------------------------------

Create generator::

    gen  = CS_SparseSignalGenerator(N, K, S);

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

::

    x = randcs(N, q, lambda, dist)



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
    sg = CS_MultiSubspaceSignalGenerator(N, K);
    % Create disjoint supports
    sg.createDisjointSupports(P);
    sg.setNumSignalsPerSubspace(SS);
    % Generate  signal representations
    sg.biUniform(1, 4);
    % Access  signal representations
    X = sg.X;
    % Corresponding supports
    qs = sg.Supports;
