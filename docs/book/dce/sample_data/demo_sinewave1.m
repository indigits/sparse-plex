close all;
clearvars;
clc;
rng default;

n = 10;
sigma = 0.25;
[x, y] = spx.data.synthetic.func.sinusoid('n', n, 'sigma', sigma);

scatter(x, y);
hold on;

[x, y, res] = spx.data.synthetic.func.sinusoid('n', 500, 'sigma', 0);
plot(x, y);

xlim([res.min - .1, res.max + 0.1]);
ylim([-1.2, 1.2]);

grid 'on';
legend({'noisy', 'clean'});

title(sprintf('Sine wave with noise $\\sigma=%0.2f$', sigma),'interpreter','latex');
saveas(gcf, 'images/sinewave_1.png');