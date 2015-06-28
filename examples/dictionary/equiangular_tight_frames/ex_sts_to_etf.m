close all; clear all; clc;
M = SPX_SteinerSystem.ss_2(4);
result = SPX_EquiangularTightFrame.ss_to_etf(M);
frame = result.F;
props = SPX_DictProps(frame);
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
SPX_EquiangularTightFrame.is_etf(frame)

