close all;
clearvars;
clc;
rng default;

degree = 4;

n = 20;
sigma = 0.25;
[x, t] = spx.data.synthetic.func.sinusoid('n', n, 'sigma', sigma);

features = spx.ml.features.polynomial(x, degree);

model = spx.ml.models.linear.LinearRegression;
model.fit(features, t)

n2 = 1000;
[x2, t2, res] = spx.data.synthetic.func.sinusoid('n', n2, 'sigma', 0);

features2 = spx.ml.features.polynomial(x2, degree);

y2 = model.predict(features2);

if 0
spx.io.print.vector(t2, 3);
spx.io.print.vector(y2, 3);
end


plot(x2, t2);
hold on;

plot(x2, y2);

legend({'real', 'predicted'});
