clear all;
close all;
clc;
export = true;
configs = cell(1, 5);
configs{1} = create_config([1 1 1 1 1 1], 4, '1-4');
configs{2} = create_config([2 1 1 1 1 1], 4, '2.1-4');
configs{3} = create_config([4 2 1 1 1 1], 4, '42.1-4');
configs{4} = create_config([2 2 2 2 2 2], 4, '2-4');
configs{5} = create_config([2 2 2 2 2 2], 8, '2-8');

nc = numel(configs);

points = [150  275  490  885 1600 2885 5205 9400 16980];
nns = numel(points);
clustering_acc_perc_mat = zeros(nc, nns);
spr_perc_mat = zeros(nc, nns);
spr_error_perc_mat = zeros(nc, nns);

for c=1:nc
    config = configs{c};
    if isempty(config)
        continue;
    end
    solver_name = sprintf('ssc_mc_omp_%s', config.name);
    filepath = sprintf('bin/solver_%s.mat', solver_name);
    load(filepath);

    clustering_acc_perc_mat(c, :)  = result.clustering_acc_perc_arr;
    spr_perc_mat(c, :) = result.spr_perc_arr;
    spr_error_perc_mat(c, :) = 100 * result.spr_error_arr;
    fprintf('%s Points: \n', solver_name);
    fprintf('%4d ', result.num_points_arr);
    fprintf('\n');

    fprintf('Accuracy: \n');
    fprintf('%.2f ', result.clustering_acc_perc_arr);
    fprintf('\n');

    % plot_bench_results(result, solver_name);
end

legends = {'OMP', 'MC-OMP 2.1-4', 'MC-OMP 42.1-4', 'MC-OMP 2-4', 'MC-OMP 2-8'};

fprintf('\n\nAccuracy: \n');
disp(clustering_acc_perc_mat);

fprintf('\nSubspace preserving representations: \n');
disp(spr_perc_mat);

fprintf('\nSubspace representation error: \n');
disp(spr_error_perc_mat);


styles = spx.graphics.plot_styles();
mf = spx.graphics.Figures;
mf.new_figure('Clustering Accuracy');
for c=1:nc
    style = styles{c};
    plot(points, clustering_acc_perc_mat(c, :), style);
    hold on;
end
xlabel('Points');
ylabel('Clustering accuracy (%)');
ylim([40 100]);
grid on;
legend(legends, 'Location', 'SouthEast');
if export
set(gcf, 'units', 'inches', 'position', [.8 .8 4 3]);
set(gca,'FontSize',8);
set(findall(gcf,'type','text'),'FontSize',8);
export_fig plots/clustering_accuracy.png -r120 -nocrop;
export_fig plots/clustering_accuracy.pdf;
end

mf.new_figure('Subspace preserving representations');
for c=1:nc
    style = styles{c};
    plot(points, spr_perc_mat(c, :), style);
    hold on;
end
xlabel('Points');
ylabel('Subspace preserving representation percentage (%)');
ylim([0 100]);
grid on;
legend(legends, 'Location', 'SouthEast');
if export
set(gcf, 'units', 'inches', 'position', [.8 .8 4 3]);
set(gca,'FontSize',8);
set(findall(gcf,'type','text'),'FontSize',8);
export_fig plots/subspace_preserving_representation_perc.png -r120 -nocrop;
export_fig plots/subspace_preserving_representation_perc.pdf;
end


mf.new_figure('Subspace representation error');
for c=1:nc
    style = styles{c};
    plot(points, spr_error_perc_mat(c, :), style);
    hold on;
end
xlabel('Points');
ylabel('Subspace representation error  (%)');
ylim([0 50]);
grid on;
legend(legends);
if export
set(gcf, 'units', 'inches', 'position', [.8 .8 4 3]);
set(gca,'FontSize',8);
set(findall(gcf,'type','text'),'FontSize',8);
export_fig plots/subspace_representation_error_perc.png -r120 -nocrop;
export_fig plots/subspace_representation_error_perc.pdf;
end
