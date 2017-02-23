close all;
clear all;
clc;
png_export = true;
pdf_export = true;


load('bin/omp_vs_multiple_omp_ar_versions.mat');

mf = spx.graphics.Figures();

mf.new_figure('Average matchings per iteration');

hold all;

plot(Ks, ones(num_ks, 1) * N);
for nri=1:num_ris
    plot(Ks, omp_ar_average_matches_with_k(:, nri));
end
xlabel('Sparsity level');
ylabel('Average number of matchings per iteration');
legend({'OMP', 'OMP-AR RI=4', 'OMP-AR RI=5'});
ylim([0, 1200]);
xlim([1, 80]);
grid on;

if png_export
export_fig bin/matchings_per_iteration.png -r120 -nocrop;
end
if pdf_export
export_fig bin/matchings_per_iteration.pdf;
end



mf.new_figure('Success rate');
hold all;
plot(Ks, omp_success_rates_with_k, '-.');
for nri=1:num_ris
    plot(Ks, omp_ar_success_rates_with_k(:, nri), ':');
end
xlabel('Sparsity level');
ylabel('Success rates');
legend({'OMP', 'AR-OMP RI=4', 'AR-OMP RI=5'});
grid on;

if png_export
export_fig bin/success_rate.png -r120 -nocrop;
end
if pdf_export
export_fig bin/success_rate.pdf;
end

