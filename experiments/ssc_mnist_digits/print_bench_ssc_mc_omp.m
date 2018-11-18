configs = cell(1, 4);
configs{1} = create_config([1 1 1 1 1 1 1 1 1 1], 4, '1-4');
configs{2} = create_config([2 1 1 1 1 1 1 1 1 1], 4, '2.1-4');
configs{3} = create_config([4 2 1 1 1 1 1 1 1 1], 4, '42.1-4');
configs{4} = create_config([2 2 2 2 2 2 2 2 2 2], 4, '2-4');
num_samples_per_digit_arr = [50 80 100 150 200 300 400];

%num_samples_per_digit_arr = [50 80 100 150 200 300 400];

nns = numel(num_samples_per_digit_arr);
nc = numel(configs);

results = cell(nns, nc);
clustering_error_perc_mat = zeros(nns, nc);
clustering_acc_perc_mat = zeros(nns, nc);
elapsed_time_mat = zeros(nns, nc);
spr_error_mat = zeros(nns, nc);

for ns=1:nns
    num_samples_per_digit = num_samples_per_digit_arr(ns);
    for c=1:nc
        config = configs{c};
        solver_name = sprintf('ssc_mc_omp_%s', config.name);
        filepath = sprintf('bin/%s_digits=%d.mat', solver_name, num_samples_per_digit);
        load(filepath);
        results{ns, c} = result;
        clustering_acc_perc_mat(ns, c) = result.clustering_acc_perc;
        clustering_error_perc_mat(ns, c) = result.clustering_error_perc;
        elapsed_time_mat(ns, c) = result.elapsed_time;
        spr_error_mat(ns, c) = result.spr_error;
    end
end

fprintf('Samples per digit: ');
fprintf('%d ', num_samples_per_digit_arr);
fprintf('\n');

fprintf('Clustering accuracy: \n');
disp(clustering_acc_perc_mat');

fprintf('Subspace representation error: \n');
disp(spr_error_mat');


headers = {'Images per Digit'};
for c=1:nc
    headers{end+1} = configs{c}.name;
end
fprintf('Clustering accuracy a%%\n\n');
data = [num_samples_per_digit_arr' clustering_acc_perc_mat];
spx.io.rst.print_list_table(data, headers);

fprintf('Subspace preserving representation error e%%\n\n');
data = [num_samples_per_digit_arr' spr_error_mat*100];
spx.io.rst.print_list_table(data, headers);


fprintf('Time t\n\n');
data = [num_samples_per_digit_arr' elapsed_time_mat];
spx.io.rst.print_list_table(data, headers);
