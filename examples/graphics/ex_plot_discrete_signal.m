close all; clear all; clc;

spx.graphics.plot.discrete_signal(randn(1, 200));
spx.graphics.plot.discrete_signal(randn(1, 400));

data = randi([1, 6], 1, 1000);
pmf = spx.stats.relative_frequencies(data);
is_pmf = spx.probability.is_pmf(pmf);
options.title = 'Distribution';
options.xlabel = 'Face';
options.ylabel = 'Probability';
options.xstep = 1;
spx.graphics.plot.discrete_signal(pmf, options);
