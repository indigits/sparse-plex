close all; clear all; clc;

load omp_representations;
[D, total_images] = size(representations);
num_subjects = 38;
images_per_subject = total_images / num_subjects;
svd_data = zeros(images_per_subject, num_subjects);
fprintf('\n Computing SVD');
tstart = tic;
for i=0:(num_subjects-1)
    Y = representations(2:end, i*images_per_subject + (1:images_per_subject));
    s = svd(Y);
    svd_data(:, i + 1) = s;
    fprintf('Subject: %d\n', i);
end
elapsed = toc(tstart);
fprintf('Time taken: %.2f seconds \n', elapsed);
save('omp_rep_svd_data', 'svd_data');


