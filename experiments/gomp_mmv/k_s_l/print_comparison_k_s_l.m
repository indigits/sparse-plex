close all;
clear all;
clc;
rng('default');

png_export = true;
pdf_export = false;

mf = spx.graphics.Figures();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Signal space 
N = 256;
% Number of measurements
M = 48;


if true
% Signal space 
N = 1000;
% Number of measurements
M = 200;
end


filename  = sprintf('bin/comparison_with_k_s_with_N=%d_M=%d.mat', N, M);
load(filename)

for ns=1:num_ss
    S = Ss(ns);
    plt_title = sprintf('Recovery performance for %d signals', S);

    mf.new_figure(plt_title);


    hold all;
    legends = cell(1, 1);

    algorithm = 0;

    % algorithm = algorithm + 1;
    % plot(Ks, success_rates.ra_ormp(:, ns), '-+');
    % legends{algorithm} = 'RA-ORMP';

    % algorithm = algorithm + 1;
    % plot(Ks, success_rates.ra_omp(:, ns), '-o');
    % legends{algorithm} = 'RA-OMP';

    algorithm = algorithm + 1;
    plot(Ks, success_rates.omp_mmv(:, ns), '-s');
    legends{algorithm} = 'SOMP';

    algorithm = algorithm + 1;
    plot(Ks, success_rates.gomp_2_mmv(:, ns), '-d');
    legends{algorithm} = 'GOMP-MMV (L=2)';

    algorithm = algorithm + 1;
    plot(Ks, success_rates.gomp_4_mmv(:, ns), '-x');
    legends{algorithm} = 'GOMP-MMV (L=4)';

    grid on;
    xlabel('Sparsity Level');
    ylabel('Recovery Probability');
    legend(legends, 'Location', 'west');
    title(plt_title);

end