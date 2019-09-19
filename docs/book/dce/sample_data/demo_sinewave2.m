close all;
clearvars;
clc;
rng default;

n = 25;
sigma = 0.25;
x_min = 0;
x_max = 2;
f = 2;
[x, y] = spx.data.synthetic.func.sinusoid('n', n, 'sigma', sigma, 'min', x_min, 'max', x_max, 'f', f);

scatter(x, y);
hold on;

[x, y, res] = spx.data.synthetic.func.sinusoid('n', 500, 'sigma', 0, 'min', x_min, 'max', x_max, 'f', f);
plot(x, y);

xlim([res.min - .1, res.max + 0.1]);
ylim([-1.2, 1.2]);

grid 'on';
legend({'noisy', 'clean'});

title(sprintf('Sine wave with noise $\\sigma=%0.2f$', sigma),'interpreter','latex');
saveas(gcf, 'images/sinewave_2.png');