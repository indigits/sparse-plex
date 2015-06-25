close all; clear all; clc;
% Create the directory for storing images
[status_code,message,message_id] = mkdir('bin');


resize_images = false;
fprintf('Loading Yale faces.\n');
tstart = tic;
yf = SPX_YaleFaces();
yf.load();
fprintf('Faces have been loaded.\n');
elapsed = toc(tstart);
fprintf('Time taken: %.2f seconds \n', elapsed);
if resize_images
    fprintf('\n Resizing images');
    tstart = tic;
    yf.resize_all(42, 48);
    elapsed = toc(tstart);
    fprintf('Time taken: %.2f seconds \n', elapsed);
end

ns = yf.num_subjects();
ni = yf.ImagesToLoadPerSubject;
svd_data = zeros(ni, ns);
fprintf('\n Computing SVD');
tstart = tic;
for i=1:ns
    Y = yf.get_subject_images(i);
    s = svd(Y);
    svd_data(:, i) = s;
    fprintf('Subject: %d\n', i);
end
elapsed = toc(tstart);
fprintf('Time taken: %.2f seconds \n', elapsed);
save('bin/svd_data', 'svd_data');

% Use print_svd_data script to print the data.