close all;
clearvars;
clc;
rng('default');

m = 100;
n = 100;

% C = A + B
% A is the sparse part

% rank of the low rank part B
b_rank = 2;

% sparsity ratio of A
a_spr = 0.02;

% Construct the low rank matrix
B0 = randn(m, b_rank) * randn(b_rank, n);

% Construct the sparse matrix
A0 = zeros(m, n);
% permute the m*n indices
p = randperm(m*n);
% number of indices to keep
l = round(a_spr * m*n);
% select l indices
indices = p(1:l);
% fill A at these indices
A0(indices) = randn(l, 1);

% complete matrix
C = A0 + B0;

% solve the decomposition problem
[A, B, details] = spx.opt.admm.lrsd_yy(C);

fprintf('Number of iterations: %d\n', details.iterations);

tx = 13;  
figure(1);  set(1,'position',[0,100,400,400]);
subplot(121); imshow(A0,[]);     title('True Sparse','fontsize',tx);
subplot(122); imshow(A,[]);  title('Recovered Sparse','fontsize',tx);
colormap(bone(5));

figure(2); set(2,'position',[420,100,400,400]);
subplot(121); imshow(B0,[]); title('True Low-Rank','fontsize',tx);
subplot(122); imshow(B,[]); title('Recovered Low-Rank','fontsize',tx);
colormap(bone(5));


