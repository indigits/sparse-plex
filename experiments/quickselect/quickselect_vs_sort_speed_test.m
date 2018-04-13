clc;
close all;
clearvars;

n = 800000;
k = 100;
trials = 100;

sort_elapsed = 0;
quickselect_elapsed = 0;
for i=1:trials
    data = -randperm(n);
    tstart = tic;
    sort(data);
    sort_elapsed = sort_elapsed + toc(tstart);
    tstart = tic;
    y = spx.fast.quickselect(data, k);
    quickselect_elapsed = quickselect_elapsed + toc(tstart);
    fprintf('%d  %d\n', y(k), sum (y(1:k) < -k));
end


t1 = sort_elapsed;
t2 = quickselect_elapsed;
gain_x = t1 / t2;

fprintf('Sort: %.2f sec, quickselect: %.2f sec, Gain: %.2f\n', t1, t2, gain_x);



