% In this example we consider a 127 dimensional space.
% We choose vectors in this space by removing a row from a 128 x 128 Hadamard matrix.
% We then construct 2 d-dimensional subspaces by choosing vectors from this set
% randomly.
% We then measure the principal angle between such a pair of subspaces.
% We repeat it for t trials of random d-dimensional subspaces.
% We vary d from 1 to 64.
% Finally we plot the variation of principal angle with number of dimensions.
% We note that as the subspace dimension increases, the principal angle between
% two randomly chosen subspaces [with basis vectors from the Hadamard matrix]
% keeps decreasing.

clc; clear all;close all;
% Construct a Hadamard matrix
n = 128;
h = hadamard(n);
% drop one row
h2 = h(1:end-1, :);
% normalize the vectors
h2 = SPX_Norm.normalize_l2(h2);
% compute it's Gram matrix
g = h2' * h2;
% verify that absolute value of all the non-zero elements is 1/(n -1).

trials = 2;

least_angles = [];
ds = [];

% The size of subspace
for d = 1:n/2
    fprintf('Choosing subspace dimension: %d\n', d);
    for t=1:trials
        % select two independent subspaces
        indices = randperm(n, 2*d);
        A = h2(:, indices(1:d));
        B = h2(:, indices(d+1:end));
        angles = SPX_Spaces.principal_angles_cos(A, B);
        least_angle = angles(1);
        least_angle_deg = rad2deg(acos(least_angle));

        fprintf('Trial: %d, smallest principal angle: %.4f, %.2f degrees\n', t, ...
            least_angle, least_angle_deg);
    end
    ds = [ds d];
    least_angles = [least_angles least_angle_deg];
end
plot(ds, least_angles);
xlabel('D');
ylabel('Angle (degrees)');
grid on;
