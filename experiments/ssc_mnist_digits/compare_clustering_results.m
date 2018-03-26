function result = compare_clustering_results(num_subjects)
    if nargin < 1
        num_subjects = 2;
    end
    close all;
    clc;
    result1 = merge_results(num_subjects, 'ssc_omp');
    result2 = merge_results(num_subjects, 'ssc_mc_omp');

    cep = [result1.clustering_error_perc_vec result2.clustering_error_perc_vec];
    cep = [(1:size(cep, 1))' cep cep(:, 2)  - cep(:, 1)]
    mcep = mean(cep);


    cap = [result1.clustering_acc_perc_vec result2.clustering_acc_perc_vec];
    cap = [(1:size(cap, 1))' cap cap(:, 2)  - cap(:, 1)]
    mcap = mean(cap);


    spp = [result1.spr_perc_vec result2.spr_perc_vec];
    spp = [(1:size(spp, 1))' spp spp(:, 2)  - spp(:, 1)]
    mspp = mean(spp);

    sprep = [result1.spr_error_vec*100 result2.spr_error_vec*100];
    sprep = [(1:size(sprep, 1))' sprep sprep(:, 2)  - sprep(:, 1)]
    msprep = mean(sprep);


    result.cep = cep;
    result.mcep = mcep;
    result.cap = cap;
    result.mcap = mcap;
    result.spp = spp;
    result.mspp = mspp;
    result.sprep = sprep;
    result.msprep = msprep;

    mcep
    mcap
    mspp
    msprep
    % figure;
    % plot(result1.clustering_error_perc_vec);
    % hold on;
    % plot(result2.clustering_error_perc_vec);
    % legend({'ssc-omp', 'ssc-mc-omp'});
end