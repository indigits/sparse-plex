function print_bench_results(result, solver_name)
    mf = spx.graphics.Figures;


    mf.new_figure('Clustering error');
    semilogx (result.num_points_arr, result.clustering_error_perc_arr, '-s');
    xlabel('Points');
    ylabel('Clustering error (%)');
    grid on;

    mf.new_figure('Clustering accuracy');
    semilogx (result.num_points_arr, result.clustering_acc_perc_arr, '-s');
    xlabel('Points');
    ylabel('Clustering accuracy (%)');
    ylim([40 100]);
    grid on;

    mf.new_figure('Subspace preserving representation error');
    semilogx (result.num_points_arr, result.spr_error_arr * 100, '-s');
    xlabel('Points');
    ylabel('Subspace preserving representation error (%)');
    ylim([0 50]);
    grid on;

    mf.new_figure('Subspace preserving representation percentage');
    semilogx (result.num_points_arr, result.spr_perc_arr, '-s');
    xlabel('Points');
    ylabel('Subspace preserving representation percentage (%)');
    ylim([0 100]);
    grid on;


    mf.new_figure('Connectivity');
    semilogx (result.num_points_arr, result.connectivity_arr, '-s');
    xlabel('Points');
    ylabel('Connectivity');
    ylim([0 0.2]);
    grid on;

    mf.new_figure('Computation time');
    loglog (result.num_points_arr, result.elapsed_time_arr, '-s');
    xlabel('Points');
    ylabel('Computation time (seconds)');
    grid on;

end
