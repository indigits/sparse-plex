% Shows the usage of alternate projections to construct a Grassmannian frame
close all; clear all; clc;
rng('default');
% Create the directory for storing images
[status_code,message,message_id] = mkdir('bin');
N = 64;
D = 121;
dict = spx.dict.simple.gaussian_dict(N, D);
% dict = spx.dict.simple.overcomplete2DDCT(N, D);
initial_dictionary = dict.A;
options.iterations = 1000;
result = SPX_Grassmannian.alternate_projections(initial_dictionary, options);
final_dictionary = result.dictionary;
fprintf('Signal space dimension: %d\n', N);
fprintf('Number of atoms: %d\n', D);
fprintf('Number of off-diagonal entries in D: %d\n', D^2 - D);
fprintf('Rank of final dictionary: %d\n', rank(final_dictionary));
initial_coherence = coherence(initial_dictionary);
fprintf('Initial coherence: %12.8f\n', initial_coherence);
fprintf('Target coherence: %12.8f\n', result.target_coherence);
fprintf('Iterations: %6i\n', result.iterations);
fprintf('Final coherence: %12.8f\n', coherence(final_dictionary));
save('bin/dictionary.mat', 'final_dictionary');

mf = spx.graphics.Figures();
mf.new_figure('Gram matrices');
initial_gram = initial_dictionary'*initial_dictionary;
final_gram  = final_dictionary' * final_dictionary;
% the following image has
% original gram matrix in TL corner
% final gram matrix in TR corner
% initial gram matrix absolute values in BL corner.
% final gram matrix absolute values in BR corner.
gram_image = [initial_gram, ones(D, 2), final_gram
         ones(2, 2*D + 2)
         abs(initial_gram), ones(D, 2), abs(final_gram)];
imagesc(gram_image);
colorbar; 
colormap(gray(256))
axis image
axis off;

mf.new_figure('Coherence improvement graph');
clf;
h=semilogx(result.coherence_array,'b'); hold on; 
set(h,'LineWidth',2); 
h=semilogx(result.mean_coherence_array,'r'); hold on; 
set(h,'LineWidth',2); 
h=semilogx(result.target_coherence*ones(result.iterations, 1),'g');
set(h,'LineWidth',2); 
axis([0 result.iterations 0 initial_coherence + .1]); 
legend({'Obtained \mu','mean coherence','Optimal \mu'},1); 
set(gca,'FontSize',14);

mf.new_figure('Inner products');
clf;
sorted_initial_gram = sort(initial_gram(:));
% remove the D diagonal elements
sorted_initial_gram= sorted_initial_gram(1:end-D); 
h=plot(sorted_initial_gram); 
set(h,'LineWidth',2); 
hold on; 
sorted_final_gram = sort(final_gram(:));
% remove the D diagonal elements
sorted_final_gram=sorted_final_gram(1:end-D); 
h=plot(sorted_final_gram,'r'); 
set(h,'LineWidth',2); 
grid on; 
axis([0 (D^2-D) (-initial_coherence -.1) (initial_coherence + .1)]);
opt_mu = result.target_coherence;
h=plot([1,D*(D-1)],[opt_mu, opt_mu],'g'); 
set(h,'LineWidth',2); 
legend({'Initial Gram','Final Gram','Optimal \mu'},2); 
h=plot([1,D*(D-1)],[-opt_mu,-opt_mu],'g'); 
set(h,'LineWidth',2); 
set(gca,'FontSize',14);
