function ex_ssc_mc_omp(md, num_samples_per_digit)
    if nargin < 1
        error('database must be loaded.');
    end
    if nargin < 2
        num_samples_per_digit = 50;
    end
    close all;
    clc;
    config = create_config([4 2 1 1 1 1 1 1 1 1], 8, '42.1-8');
    check_digits(md, num_samples_per_digit, @ssc_mc_omp, 'ssc_mc_omp', config);
end
