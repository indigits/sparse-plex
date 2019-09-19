
close all;
clearvars;
clc;
rng default;

degrees = [1 3 5 9];


n = 10;
sigma = 0.25;
[x_train, t_train] = spx.data.synthetic.func.sinusoid('n', n, 'sigma', sigma);


n2 = 100;
[x_test, t_test] = spx.data.synthetic.func.sinusoid('n', n2, 'sigma', 0);


for iter=1:numel(degrees)
    degree = degrees(iter);
    subplot(2,2, iter);
    features_train = spx.ml.features.polynomial(x_train, degree);
    model = spx.ml.models.linear.LinearRegression;
    model.fit(features_train, t_train);
    features_test = spx.ml.features.polynomial(x_test, degree);
    y_test = model.predict(features_test);
    hold on;
    scatter(x_train, t_train);
    plot(x_test, t_test);
    plot(x_test, y_test);
    ylim([-1.5, 1.5]);
    xlim([-0.1, 1.1]);
    grid on;
    title(sprintf('degree=%d', degree));
end
