close all ;
clear all;
clc;
% Create the directory for storing images
[status_code,message,message_id] = mkdir('bin');

export = true;

mf = spx.graphics.Figures();
mf.new_figure('Optimum Grassmannian Coherence');
hold on;
Ms = [4, 8, 12, 16];
nM = length(Ms);
legends = cell(nM, 1);
cc=hsv(nM);
for mi=1:nM
    M = Ms(mi);
    NMax = M * (M + 1) / 2;
    Ns  = M+1:NMax;
    coherence = sqrt ( (Ns - M) ./ (M * (Ns - 1)) ) ;

    plot (Ns, coherence, 'color',cc(mi,:));
    legends{mi} = sprintf('K=%d', M);
end
xlabel('Number of vectors');
ylabel('Optimum coherence');
grid on;
legend(legends);

if export
set(gcf, 'units', 'inches', 'position', [1 1 4 3]);
set(gca,'FontSize',8);
set(findall(gcf,'type','text'),'FontSize',8);
export_fig bin/optimal_grassmannian_coherence.png -r120 -nocrop;
export_fig bin/optimal_grassmannian_coherence.pdf;
end

all_angles = cell(nM, 1);
max_ns = zeros(nM, 1);

mf.new_figure('Optimum Grassmannian angles');
hold on;
for mi=1:nM
    M = Ms(mi);
    NMax = M * (M + 1) / 2;
    max_ns(mi) = NMax;
    Ns  = M+1:NMax;
    coherence = sqrt ( (Ns - M) ./ (M * (Ns - 1)) ) ;
    angles = acos(coherence);
    angles = rad2deg(angles);
    all_angles{mi} = angles;
    plot (Ns, angles, 'color',cc(mi,:));
    legends{mi} = sprintf('K=%d', M);
end
xlabel('Number of vectors');
ylabel('ETF angle (degree)');
grid on;
legend(legends);

if export
set(gcf, 'units', 'inches', 'position', [1.2 1.2 4 3]);
set(gca,'FontSize',8);
set(findall(gcf,'type','text'),'FontSize',8);
export_fig bin/optimal_grassmannian_angles.png -r120 -nocrop;
export_fig bin/optimal_grassmannian_angles.pdf;
end
