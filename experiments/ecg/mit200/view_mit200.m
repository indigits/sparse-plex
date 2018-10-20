close all; clearvars; clc;
load mit200;
plot(tm, ecgsig);
grid on;
xlabel('second');
ylabel('amplitude');
hold on;
plot(tm(ann), ecgsig(ann), 'ro');

