function bench_ssc_mc_omp(md)

configs = cell(1, 4);
configs{1} = create_config([1 1 1 1 1 1 1 1 1 1], 4, '1-4');
configs{2} = create_config([2 1 1 1 1 1 1 1 1 1], 4, '2.1-4');
configs{3} = create_config([4 2 1 1 1 1 1 1 1 1], 4, '42.1-4');
configs{4} = create_config([2 2 2 2 2 2 2 2 2 2], 4, '2-4');
num_samples_per_digit_arr = [50 80 100 150 200 300 400];

nns = numel(num_samples_per_digit_arr);
nc = numel(configs);
for ns=1:nns
    num_samples_per_digit = num_samples_per_digit_arr(ns);
    for c=1:nc
        config = configs{c};
        solver_name = sprintf('ssc_mc_omp_%s', config.name);
        fprintf('Simulating: %s, for %d samples per digit\n', solver_name, num_samples_per_digit);
        result = check_digits(md, num_samples_per_digit, @ssc_mc_omp, solver_name, config);
        filepath = sprintf('bin/%s_digits=%d.mat', solver_name, num_samples_per_digit);
        save(filepath, 'result');
    end
end

end

