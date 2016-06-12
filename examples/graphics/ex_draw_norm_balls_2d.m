close all;
clear all;
clc;
% Create the directory for storing images
[status_code,message,message_id] = mkdir('bin');

mf = spx.graphics.Figures();
mf.new_figure('Demo norm balls');
hold on;
R = 5;
h1 = spx.graphics.draw.norm_ball_2d(0, 0, 5, 0.3, 'color', 'r');
h2 = spx.graphics.draw.norm_ball_2d(0, 0, 5, 0.5, 'color', 'g');
h3 = spx.graphics.draw.norm_ball_2d(0, 0, 5, 1, 'color', 'b');
h4 = spx.graphics.draw.norm_ball_2d(0, 0, 5, 2, 'color', 'k');
h5 = spx.graphics.draw.norm_ball_2d(0, 0, 5, 20, 'color', 'm');
hplots  = [h1 h2 h3 h4 h5];
legends = {'l_{0.3}' 'l_{0.5}' 'l_{1}' 'l_{2}' 'l_{20}'};
%legend(hplots, legends);
sz = 6;
axis([-sz sz -sz sz]);
axis equal;
xlabel('x_1');
ylabel('x_2');
title('Norm balls for R^2');
print -dpng -r120 bin/norm_ball_2d;
