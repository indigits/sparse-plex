Binary Hypothesis Testing
=============================================

.. highlight:: matlab

Generate a sequence of bits::

    % Number of bits being transmitted
    B = 1000*100;
    transmittedBits = randi(2, B , 1)  - 1;

Modulation::

    % Number of samples per detection test.
    N = 10;
    % The signal shape
    signal = ones(N, 1);
    transmittedSequence = SPX_Modulator.modulate_bits_with_signals(transmittedBits, signal);

Adding noise::

    sigma = 1;
    noise = sigma * randn(size(transmittedSequence));
    % We add noise to transmitted data to create received sequence
    receivedSequence = transmittedSequence + noise;

Matched filtering::

    matchedFilterOutput = matchedFilter(receivedSequence, signal);


Generating sufficient statistics::

    signalNormSquared = signal' * signal;
    sufficientStatistics = matchedFilterOutput / signalNormSquared;

Thresholding::

    % We define optimal detection threshold
    eta = 0.5;
    % We create the received bits 
    receivedBits = sufficientStatistics >= eta;

Detection results::

    result = SPX_BinaryHypothesisTest.performance(...
        transmittedBits, receivedBits)

    % Number of False sent, False received
    result.FF
    % Number of False sent, True received
    result.FT
    % Number of True sent, False received
    result.TF
    % Number of True sent, True received
    result.TT
    % Number of times hypothesis 0 was sent. 
    result.H0
    % Number of times hypothesis 1 was sent.
    result.H1
    % Number of times 0 was detected.
    result.D0
    % Number of times 1 was detected.
    result.D1
    % A priori probability of 0
    result.P0
    % A priori probability of 1
    result.P1
    % Detection probability
    result.PD
    % False alarm probability
    result.PF
    % Miss probability
    result.PM
    % Accuracy (probability of correct decisions)
    result.Accuracy
    % Probability of error
    result.Pe
    % Precision : Truth sent given that truth was detected
    result.Precision
    % Recall : Truth detected given that truth was sent.
    result.Recall
    % F1 score
    result.F1
    