% Initialize
close all; clear all; clc;
% We compute the Receiver Operating Charactersitics of signal in presence
% of Gaussian noise

sigma = 1;
N = 2;
s = ones(N, 1);
sNorm = norm(s);

alphas = 0:0.05:1;
gammas = sigma * sNorm * SPX_Prob.q_inv_function(alphas);

PF = SPX_Prob.q_function(gammas/(sigma*sNorm));
PD = SPX_Prob.q_function(SPX_Prob.q_inv_function(alphas) - sNorm / sigma);
% Scatter plot 
plot(PF, PD);
xlabel('P_F');
ylabel('P_D');
