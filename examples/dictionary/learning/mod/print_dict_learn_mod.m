% Initialize
clear all; close all; clc; 

% Load data
load('bin/ex_dict_learn_mod.mat');

export = true;

matched_atom_ratios = tracker.MatchedAtomRatios;
total_errors = tracker.TotalErrors;
iterations = tracker.Counter - 1;

mf = spx.graphics.Figures();
SPX_Display.dictionary_atoms_as_images(tracker.TrueDictionary, ...
    struct('title', 'Original Dictionary'));

if export
export_fig bin/problem_random_dict_true_dict.png -r120 -nocrop;
export_fig bin/problem_random_dict_true_dict.pdf;
end

if 1
mf.new_figure('Recovered atoms ratio');
h=plot(0:iterations, matched_atom_ratios,'k'); 
set(h,'LineWidth',2);
set(gca,'FontSize',14);
h=xlabel('Iteration');
set(h,'FontSize',14);
h=ylabel('Relative # of Recovered Atoms');
set(h,'FontSize',14);
grid on;

if export
export_fig bin/problem_random_dict_recovered_atoms_ratio.png -r120 -nocrop;
export_fig bin/problem_random_dict_recovered_atoms_ratio.pdf;
end


mf.new_figure('Average representation error');
h=plot(0:iterations, total_errors,'k'); 
set(h,'LineWidth',2);
hold on;
set(gca,'FontSize',14);
h=xlabel('Iteration');
set(h,'FontSize',14);
h=ylabel('Average Representation Error');
set(h,'FontSize',14);
grid on;

if export
export_fig bin/problem_random_dict_rep_error.png -r120 -nocrop;
export_fig bin/problem_random_dict_rep_error.pdf;
end

end


SPX_Display.dictionary_atoms_as_images(tracker.CurrentDictionary, ...
    struct('title', 'Learnt Dictionary'));

if export
export_fig bin/problem_random_dict_learnt_dict.png -r120 -nocrop;
export_fig bin/problem_random_dict_learnt_dict.pdf;
end
