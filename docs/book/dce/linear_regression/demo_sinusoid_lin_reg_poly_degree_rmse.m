
close all;
clearvars;
clc;
rng default;
rng(100);
degrees = 1:9;


n = 10;
sigma = 0.25;
[x_train, t_train] = spx.data.synthetic.func.sinusoid('n', n, 'sigma', sigma);


n2 = 100;
[x_test, t_test] = spx.data.synthetic.func.sinusoid('n', n2, 'sigma', 0);


training_errors  = [];
test_errors = [];

for iter=1:numel(degrees)
    degree = degrees(iter);
    features_train = spx.ml.features.polynomial(x_train, degree);
    model = spx.ml.models.linear.LinearRegression;
    model.fit(features_train, t_train);
    y_train = model.predict(features_train);
    features_test = spx.ml.features.polynomial(x_test, degree);
    y_test = model.predict(features_test);
    rmse_train = rms(y_train - t_train);
    rmse_test = rms(y_test - t_test);
    training_errors(end+1) = rmse_train;
    test_errors(end+1) = rmse_test;
end

hold on;
plot(degrees, training_errors, 'o-');
plot(degrees, test_errors, 'o-');
legend({'Training', 'Test'});
xlabel('Degree');
ylabel('RMSE');
