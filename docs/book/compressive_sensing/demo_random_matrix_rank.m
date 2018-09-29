M = 6;
N = 20;
trials = 10000;
n_full_rank = 0;
for i=1:trials
    % Create a random matrix of size M x N
    A = rand(M,N);
    % Obtain its rank
    R = rank(A);
    % Check whether the rank equals M or not
    if R == M
        n_full_rank = n_full_rank + 1;
    end
end
fprintf('Number of trials: %d\n',trials);
fprintf('Number of full rank matrices: %d\n',n_full_rank);
percentage = n_full_rank*100/trials;
fprintf('Percentage of full rank matrices: %.2f %%\n', percentage);

