
% Initialize
clear all; close all; clc;
png_export = true;
pdf_export = false;
% Create the directory for storing images
[status_code,message,message_id] = mkdir('bin');


% A Dirac DCT dictionary
dict = SPX_SimpleDicts.dirac_dct_mtx(16);
SPX_Display.dictionary_atoms_as_images(dict, struct('title', 'Dirac DCT Dictionary'));
if png_export
export_fig bin\dirac_dct_mtx.png -r120 -nocrop;
end
if pdf_export
export_fig bin\dirac_dct_mtx.pdf;
end


% A Gaussian dictionary
dict = SPX_SimpleDicts.gaussian_mtx(16, 64);
SPX_Display.dictionary_atoms_as_images(dict, struct('title', 'Gaussian Dictionary'));
if png_export
export_fig bin\gaussian_mtx.png -r120 -nocrop;
end
if pdf_export
export_fig bin\gaussian_mtx.pdf;
end

% A Rademacher dictionary
dict = SPX_SimpleDicts.rademacher_mtx(16, 64);
SPX_Display.dictionary_atoms_as_images(dict, struct('title', 'Rademacher Dictionary'));
if png_export
export_fig bin\rademacher_mtx.png -r120 -nocrop;
end
if pdf_export
export_fig bin\rademacher_mtx.pdf;
end

