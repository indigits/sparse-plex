%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  In this script, we perform phase transition analysis
%  of cosamp problem.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear all;
clc;
rng('default');
% Create the directory for storing results
[status_code,message,message_id] = mkdir('bin');

try
    load ('bin/cosamp_phase_transition.mat');
catch e
    fprintf('This is the first time phase transition analysis has been initiated');
    % all variables will be initiated now.
    % Our signal dimension size.
    N = 512;
    % We allow K to vary from 1 to about 7-10% of N.
    Ks = [1:32];
    Ms = [2:2:256];
    % Number of examples in each setup
    NumExamples = 1000;

    NumKs = numel(Ks);
    NumMs = numel(Ms);
    SuccessRates = zeros(NumKs, NumMs);
    TotalSimulationTimes = zeros(NumKs, NumMs);
    AverageSimulationTimes = zeros(NumKs, NumMs);
    kStart = 1;
    mStart = 1;
end


for k = kStart:NumKs
    K = Ks(k);
    % If we resume, we will resume from here.
    kStart = k;
    for m = mStart:NumMs
        M = Ms(m);
        mStart = m;
        fprintf('\n\nSimulating for K = %d, M = %d\n', K, M);
        % Construct a sensing matrix.
        Phi = SPX_SimpleDicts.gaussian_dict(M, N);
        numSuccesses = 0;
        numFailures = 0;
        tStart = tic;
        for e = 1:NumExamples
            % Construct a sparse vector
            gen = SPX_SparseSignalGenerator(N, K);
            x = gen.gaussian;
            % Construct measurement vector
            y  = Phi * x;
            % Solve the COSAMP problem
            [z, stats] = solve_cosamp(Phi, K, y, x);
            % Check whether we succeeded or failed.
            if stats.success
                numSuccesses = numSuccesses + 1;
                %fprintf('S');
            else
                numFailures = numFailures + 1;
                %fprintf('F');
            end
        end
        % Total time spent for this combination.
        totalTime = toc(tStart);
        averageTime = totalTime / NumExamples;
        successRate = numSuccesses / NumExamples;
        SuccessRates(k, m) = successRate;
        TotalSimulationTimes(k, m) = totalTime;
        AverageSimulationTimes(k, m) = averageTime;
        % We should save data for a particular value of K
        fprintf('Saving data.\n');
        save('bin/cosamp_phase_transition.mat');
    end
    % We start from first M value for next K iteration.
    mStart = 1;
end

