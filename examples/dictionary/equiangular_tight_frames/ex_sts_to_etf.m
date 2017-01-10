close all; clear all; clc;
M = spx.discrete.steiner_system.ss_2(4);
result = spx.dict.etf.ss_to_etf(M);
frame = result.F;
props = spx.dict.Properties(frame);
fprintf('Size of F: ');
fprintf('%d ', size(frame));
fprintf('\n');
disp(frame);
G = props.gram_matrix();
fprintf('Gram matrix (absolute)\n');
disp(abs(G));
% Rows are orthogonal 
fprintf('Frame operator (diagonal)\n');
disp(frame * frame');
spx.dict.etf.is_etf(frame)

