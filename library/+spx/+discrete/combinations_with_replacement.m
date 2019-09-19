function X = combinations_with_replacement(x, k)
    [m, n] = size(x);
    % It should be a row vector
    if m > 1
        x = x.';
    end
    [m, n] = size(x);
    if m > 1
        error('Input must be a row vector');
    end
    % Number of output rows
    rows = nchoosek(n+k-1, k);
    X = zeros(rows, k);
    % row index for storing a combination
    cur_row = 1;
    chosen = zeros(1, k);
    function iterate(index, r, s, e)
        if (index > r)
            X(cur_row, :) = x(chosen);
            cur_row = cur_row + 1;
            return;
        end
        for i=s:e
            chosen(index) = i;
            iterate(index + 1, r, i, e);
        end
    end
    iterate(1, k, 1, n);
end