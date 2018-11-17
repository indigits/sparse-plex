num_samples_per_digit_arr = [50 80 100 150 200 300 400];

nns = numel(num_samples_per_digit_arr);
solver_name = 'ssc_omp';

results = cell(1, nns);
clustering_error_perc_mat = zeros(1, nns);
clustering_acc_perc_mat = zeros(1, nns);
elapsed_time_mat = zeros(1, nns);
spr_error_mat = zeros(1, nns);

for ns=1:nns
    num_samples_per_digit = num_samples_per_digit_arr(ns);
    filepath = sprintf('bin/%s_digits=%d.mat', solver_name, num_samples_per_digit);
    load(filepath);
    results{ns} = result;
    clustering_acc_perc_mat(ns) = result.clustering_acc_perc;
    clustering_error_perc_mat(ns) = result.clustering_error_perc;
    elapsed_time_mat(ns) = result.elapsed_time;
    spr_error_mat(ns) = result.spr_error;
end

fprintf('Samples per digit: ');
fprintf('%d ', num_samples_per_digit_arr);
fprintf('\n');

fprintf('Clustering accuracy: \n');
disp(clustering_acc_perc_mat);

fprintf('Subspace representation error: \n');
disp(spr_error_mat);

headers = {'Points per Digit', 'a%', 'e%', 't'};
data = [num_samples_per_digit_arr' clustering_acc_perc_mat' spr_error_mat', elapsed_time_mat'];
spx.io.rst.print_list_table(data, headers);
