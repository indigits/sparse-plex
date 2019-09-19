close all;
clearvars;
clc;
rng default;

degree = 5;

n = 10;
sigma = 0.25;
[x_train, t_train] = spx.data.synthetic.func.sinusoid('n', n, 'sigma', sigma);


n2 = 10;
[x_test, t_test] = spx.data.synthetic.func.sinusoid('n', n2, 'sigma', 0);

features_train = spx.ml.features.polynomial(x_train, degree);
model = spx.ml.models.linear.LinearRegression;
model.fit(features_train, t_train);
features_test = spx.ml.features.polynomial(x_test, degree);
y_test = model.predict(features_test);


p = polyfit(x_train, t_train, degree);
py_test = polyval(p,x_test);

fprintf('t_test: ');
spx.io.print.vector(t_test, 3);
fprintf('y_test: ');
spx.io.print.vector(y_test, 3);
fprintf('py_test: ');
spx.io.print.vector(py_test, 3);

