
configs = cell(1, 5);
configs{1} = create_config([1 1 1 1 1], 4, '1-4');
configs{2} = create_config([2 1 1 1 1], 4, '2.1-4');
configs{3} = create_config([4 2 1 1 1], 4, '42.1-4');
configs{4} = create_config([8 4 2 1 1], 8, '842.1-8');
configs{5} = create_config([2 2 2 2 2], 4, '2-4');
num_subjects_arr = [2 4 6 8 10 15 20 30 38];

nns = numel(num_subjects_arr);
nc = numel(configs);

results = cell(nns, nc);
clustering_error_perc_mat = zeros(nns, nc);
clustering_acc_perc_mat = zeros(nns, nc);
elapsed_time_mat = zeros(nns, nc);
spr_error_mat = zeros(nns, nc);

for ns=1:nns
    num_subjects = num_subjects_arr(ns);
    for c=1:nc
        config = configs{c};
        solver_name = sprintf('ssc_mc_omp_%s', config.name);
        filepath = sprintf('bin/solver_name_%s_subjects=%d.mat', solver_name, num_subjects);
        load(filepath);
        results{ns, c} = result;
        clustering_acc_perc_mat(ns, c) = result.clustering_acc_perc;
        clustering_error_perc_mat(ns, c) = result.clustering_error_perc;
        elapsed_time_mat(ns, c) = result.elapsed_time;
        spr_error_mat(ns, c) = result.spr_error;
    end
end

fprintf('Number of subjects: ');
fprintf('%d ', num_subjects_arr);
fprintf('\n');

fprintf('Clustering accuracy: \n');
disp(clustering_acc_perc_mat');

fprintf('Subspace representation error: \n');
disp(spr_error_mat');
