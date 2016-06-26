function print_bench_results(results, solver_names, legends)
    mf = spx.graphics.Figures;
    styles = spx.graphics.plot_styles();

    n = numel(results);
    mf.new_figure('Clustering error');
    hold on;
    for i=1:n
        result = results{i};
        style = styles{i};
        semilogx (result.num_points_arr, result.clustering_error_perc_arr, style);
    end
    xlabel('Points');
    ylabel('Clustering error (%)');
    grid on;
    legend(legends);

    mf.new_figure('Clustering accuracy');
    hold on;
    for i=1:n
        result = results{i};
        style = styles{i};
        semilogx (result.num_points_arr, result.clustering_acc_perc_arr, style);
    end
    xlabel('Points');
    ylabel('Clustering accuracy (%)');
    ylim([40 100]);
    grid on;
    legend(legends);

    mf.new_figure('Subspace preserving representation error');
    hold on;
    for i=1:n
        result = results{i};
        style = styles{i};
        semilogx (result.num_points_arr, result.spr_error_arr * 100, style);
    end
    xlabel('Points');
    ylabel('Subspace preserving representation error (%)');
    ylim([0 50]);
    grid on;
    legend(legends);

    mf.new_figure('Subspace preserving representation percentage');
    hold on;
    for i=1:n
        result = results{i};
        style = styles{i};
        semilogx (result.num_points_arr, result.spr_perc_arr, style);
    end
    xlabel('Points');
    ylabel('Subspace preserving representation percentage (%)');
    ylim([0 100]);
    grid on;
    legend(legends);


    mf.new_figure('Connectivity');
    hold on;
    for i=1:n
        result = results{i};
        style = styles{i};
        semilogx (result.num_points_arr, result.connectivity_arr, style);
    end
    xlabel('Points');
    ylabel('Connectivity');
    ylim([0 0.2]);
    grid on;
    legend(legends);

    mf.new_figure('Computation time');
    hold on;
    for i=1:n
        result = results{i};
        style = styles{i};
        loglog (result.num_points_arr, result.elapsed_time_arr, style);
    end
    xlabel('Points');
    ylabel('Computation time (seconds)');
    grid on;
    legend(legends);

end
