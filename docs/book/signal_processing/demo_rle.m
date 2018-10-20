close all;
clearvars;
clc;
x = [0 0 0 0 0 0 0 4  4 4 3 3 2 2 2 2 2 2 2 1 1 0 0 0 0 0 2 3 9 5 5 5 5 5 5]
diff_positions = find(diff(x) ~= 0)
runs = diff([0 diff_positions numel(x)])
start_positions  = [1 (diff_positions + 1)]
symbols = x(start_positions)
encoding = [symbols; runs]
encoding = encoding(:)'
total_symbols = sum(runs)

x_dec = [];
for i=1:numel(encoding) / 2
    symbol = encoding(i*2 -1);
    run_length = encoding(i*2);
    x_dec = [x_dec symbol * ones([1, run_length])];
end
fprintf('%d ', x_dec);
fprintf('\n');
sum(x_dec - x)
