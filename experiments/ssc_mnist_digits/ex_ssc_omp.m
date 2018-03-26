function ex_ssc_omp(md, num_samples_per_digit)
    if nargin < 1
        error('database must be loaded.');
    end
    if nargin < 2
        num_samples_per_digit = 50;
    end
    close all;
    clc;
    check_digits(md, num_samples_per_digit, @ssc_omp, 'ssc_omp');
end

