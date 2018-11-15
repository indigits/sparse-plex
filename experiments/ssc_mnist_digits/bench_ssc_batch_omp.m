function bench_ssc_batch_omp(md)

num_samples_per_digit_arr = [50 80 100 150 200 300 400];

nns = numel(num_samples_per_digit_arr);
solver_name = 'ssc_batch_omp';
for ns=1:nns
    num_samples_per_digit = num_samples_per_digit_arr(ns);
    fprintf('Simulating: %s, for %d samples per digit\n', solver_name, num_samples_per_digit);
    result = check_digits(md, num_samples_per_digit, @ssc_batch_omp, solver_name);
    filepath = sprintf('bin/%s_digits=%d.mat', solver_name, num_samples_per_digit);
    save(filepath, 'result');
end

end

