function bench_ssc_mc_omp

configs = cell(1, 5);
configs{1} = create_config([1 1 1 1 1], 4, '1-4');
configs{2} = create_config([2 1 1 1 1], 4, '2.1-4');
configs{3} = create_config([4 2 1 1 1], 4, '42.1-4');
configs{4} = create_config([8 4 2 1 1], 8, '842.1-8');
configs{5} = create_config([2 2 2 2 2], 4, '2-4');
num_subjects_arr = [2 4 6 8 10 15 20 30 38];

nns = numel(num_subjects_arr);
nc = numel(configs);
for ns=1:nns
    num_subjects = num_subjects_arr(ns);
    for c=1:nc
        config = configs{c};
        solver_name = sprintf('ssc_mc_omp_%s', config.name);
        fprintf('Simulating: %s, for %d subjects\n', solver_name, num_subjects);
        result = check_yale_faces(num_subjects, @ssc_mc_omp, solver_name, config);
        filepath = sprintf('bin/%s_subjects=%d.mat', solver_name, num_subjects);
        save(filepath, 'result');
    end
end

end

