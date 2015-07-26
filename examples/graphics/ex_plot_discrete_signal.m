close all; clear all; clc;

SPX_Plot.discrete_signal(randn(1, 200));
SPX_Plot.discrete_signal(randn(1, 400));

data = randi([1, 6], 1, 1000);
pmf = SPX_Statistics.relative_frequencies(data);
is_pmf = SPX_Prob.is_pmf(pmf);
options.title = 'Distribution';
options.xlabel = 'Face';
options.ylabel = 'Probability';
options.xstep = 1;
SPX_Plot.discrete_signal(pmf, options);
