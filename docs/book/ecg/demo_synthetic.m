close all;
clearvars;
clc;

x = spx.ecg.synthetic.simple_multiple(500, 10);
figure;
plot(x);
xlabel('Time');
ylabel('Amplitude');
grid on;