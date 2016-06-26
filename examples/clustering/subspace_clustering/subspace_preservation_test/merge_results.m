function result = merge_results(solver_name)
    pattern = sprintf('bin/bench_subspace_preservation_%s_*.mat', solver_name);
    list = dir(pattern);
    max_rho_id = 0;
    num_trials = 0;
    for i=1:numel(list)
        fname = list(i).name;
        fprintf('%s\n', fname);
        filepath = fullfile('bin',  fname);
        load(filepath);
        num_trials= max(num_trials, trial.trial);
        max_rho_id = max(max_rho_id, trial.rho_id);
    end
    fprintf('Number of trials: %d, Number of rhos: %d\n',  num_trials, max_rho_id);
    result = struct;
    result.M = trial.M;
    result.K = trial.K;
    result.D = trial.D;
    result.elapsed_time_mat = zeros(num_trials, max_rho_id);
    result.connectivity_mat = zeros(num_trials, max_rho_id);
    result.clustering_error_perc_mat = zeros(num_trials, max_rho_id);
    result.clustering_acc_perc_mat = zeros(num_trials, max_rho_id);
    result.spr_error_mat = zeros(num_trials, max_rho_id);
    result.spr_flag_mat = zeros(num_trials, max_rho_id);
    result.spr_perc_mat = zeros(num_trials, max_rho_id);
    num_points_mat = zeros(num_trials, max_rho_id);
    result.trials = cell(num_trials, max_rho_id);
    for i=1:numel(list)
        fname = list(i).name;
        fprintf('%s\n', fname);
        filepath = fullfile('bin',  fname);
        load(filepath);
        r = trial.rho_id;
        tt = trial.trial;
        result.trials{tt, r} = trial;
        result.elapsed_time_mat(tt, r) = trial.elapsed_time;
        result.connectivity_mat(tt, r) = trial.connectivity;
        result.clustering_error_perc_mat(tt, r) = trial.clustering_error_perc;
        result.clustering_acc_perc_mat(tt, r) = trial.clustering_acc_perc;
        result.spr_error_mat(tt, r) = trial.spr_error;
        result.spr_flag_mat(tt, r) = trial.spr_flag;
        result.spr_perc_mat(tt, r) = trial.spr_perc;
        num_points_mat(tt, r) = trial.S;
    end
    result.num_points_arr = num_points_mat(1, :);
    result.elapsed_time_arr = mean(result.elapsed_time_mat);
    result.connectivity_arr = min(result.connectivity_mat);
    result.clustering_error_perc_arr = mean(result.clustering_error_perc_mat);
    result.clustering_acc_perc_arr = mean(result.clustering_acc_perc_mat);
    result.spr_error_arr = mean(result.spr_error_mat);
    result.spr_flag_arr = mean(result.spr_flag_mat);
    result.spr_perc_arr = mean(result.spr_perc_mat);

    fprintf('\n\n');
    fprintf('Points: ');
    fprintf('%d ', result.num_points_arr);
    fprintf('\n\n');
    fprintf('Time: ');
    fprintf('%.2f ', result.elapsed_time_arr);
    fprintf('\n\n');
    fprintf('Connectivity: ');
    fprintf('%.2f ', result.connectivity_arr);
    fprintf('\n\n');
    fprintf('Clustering error(%%): ');
    fprintf('%.2f ', result.clustering_error_perc_arr);
    fprintf('\n\n');
    fprintf('Clustering accuracy (%%): ');
    fprintf('%.2f ', result.clustering_acc_perc_arr);
    fprintf('\n\n');
    fprintf('Subspace preserving representation error: ');
    fprintf('%.2f ', result.spr_error_arr);
    fprintf('\n\n');
    fprintf('Subspace preserving representation flag: ');
    fprintf('%.2f ', result.spr_flag_arr);
    fprintf('\n\n');
    fprintf('Subspace preserving representations(%%): ');
    fprintf('%.2f ', result.spr_perc_arr);    
    fprintf('\n\n');
end
