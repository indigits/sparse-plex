close all;
clearvars;
clc;
[LoD,HiD,LoR,HiR] = wfilters('db4');

% change the DWT mode to periodization.
old_dwt_mode = dwtmode('status','nodisp');
dwtmode('per');

[LoD,HiD,LoR,HiR] = wfilters('db4');

N = 1024;
L = 4;

PsiT = zeros(N, N);
for i=1:N
    unit_vec = zeros(N, 1);
    unit_vec(i) = 1;
    [coefficients, levels] = wavedec(unit_vec, L, LoD,HiD);
    PsiT(:, i) = coefficients;
end

norms = spx.norm.norms_l2_rw(PsiT);
fprintf('norms: min: %.4f, max: %.4f\n', min(norms), max(norms));

% the synthesis matrix
Psi = PsiT';

% verify that the operations conducted 
% by the ONB bases and wavedec / waverec 
% functions are identical.
load noisdopp;
%  make it a column vector
noisdopp = noisdopp';

[a1, levels] = wavedec(noisdopp, L, LoD, HiD);
a2 = PsiT * noisdopp;
fprintf('Decomposition diff: %e\n', max(a1 - a2));

x1  = waverec(a1, levels, LoR, HiR);
x2 = Psi * a2;
fprintf('Synthesis diff: %e\n', max(x1 - x2));

% restore the old DWT mode
dwtmode(old_dwt_mode);

figure;
colormap('gray');
imagesc(Psi);
colorbar;

export_fig images/wavelet_basis_db4_level_4_N_1024.png -r120 -nocrop;
