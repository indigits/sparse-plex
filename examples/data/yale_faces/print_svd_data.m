close all; clear all; clc;
[status_code,message,message_id] = mkdir('bin/images');

export = true;
omp_rep = false;



orig = load('bin/svd_data');
mf = spx.graphics.Figures();
mf.new_figure('Original SVD');
plot(orig.svd_data);
ylabel('Singular values of several subjects');
title( 'Extended Yale Database Original Data');
grid on;


if export
export_fig bin/images/signal_space_svd.png -r120 -nocrop;
export_fig bin/images/signal_space_svd.pdf;
end

if omp_rep
    rep = load('bin/omp_rep_svd_data');
    mf.new_figure('OMP Rep SVD');
    plot(rep.svd_data);
    ylabel('Singular values of several subjects');
    title( 'Extended Yale Database OMP Representations');
    grid on;


    if export
    export_fig bin/images/representation_space_svd.png -r120 -nocrop;
    export_fig bin/images/representation_space_svd.pdf;
    end
end
