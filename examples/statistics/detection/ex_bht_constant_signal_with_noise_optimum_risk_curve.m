%% Computes optimum Risk for various values of P1

%% Initialization
clear all; close all; clc;


% We setup our test bed.
% The different a-priori probabilities we will try out.
P1Values = 0:0.02:1;
% Our cost matrix for this simulation
C = [0.0 1; 1 0];
% Variance of noise which will be used for this test
sigma  = 4;
% Number of bits which will be used per simulation
B = 1000*1000;
% Initialize an empty array to store risk values
risks = zeros(size(P1Values));
K = length(P1Values);
for i=1:K
    % Current P1 (a priori probability of H1)
    P1 = P1Values(i);
    % We run the simulation for optimum Bayes detector
    result = SPX_BHTSimulator.constant_signal_with_gaussian_noise(P1, C, sigma)
    % We compute the optimum risk based on experimental values of PF PD
    risks(i) = SPX_BinaryHypothesisTest.bayes_risk(C, result.PF, result.PD, P1);
end
% We plot the optimum risk values against a-priori probabilities
plot(P1Values, risks);
xlabel('P_1');
ylabel('Risk');
title('Optimum Risk vs. a priori probability');

