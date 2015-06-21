function [ K, columns ] = spark( Phi )
%SPARK Calculates the spark of a given matrix Phi
% Let us get the rank of matrix
R = rank(Phi);
% Number of rows and columns of Phi
[~,N] = size(Phi);
for K=1:R+1
    % Possible number of choices of K columns
    % from N columns
    if K > N
        % This happens when we have 
        % an NxN full rank matrix
        break;
    end
    numChoices = nchoosek(N,K);
    if (numChoices > 40000)
        error('N=%d, K=%d too large!',N,K);
    end
    % All possible choices of K columns out of N
    choices = nchoosek(1:N, K);
    % We iterate over choices
    for c=1:numChoices
        choice = choices(c, :);
        % We choose K columns out of N columns
        Phik = Phi (:, choice);
        % We compute the rank of this matrix
        r = rank(Phik);
        % We check if the columns are linearly 
        % dependent.
        if r < K
            % We have found a set of columns
            % which are linearly dependent
            columns = choice;
            return
        end
    end
end
% All columns up to rank K are 
% linearly independent
K = R+1;
columns = 1:N;
end

