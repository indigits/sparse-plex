classdef SPX_Arrangements < handle

methods(Static)

    function arrangement = balls_and_bins(num_balls, num_bins)
        % This function builds the arrangement of 
        % N balls in M bins
        % For Veronese map, N balls means the degree
        % of the polynomial and M bins mean the
        % M variables.
        % Returns a matrix where each column indicates
        % the bin number and each row indicates an 
        % arrangement. 
        % the cell represents the number of balls assigned
        % to a particular bin in each arrangement.


        % we will compute arrangements iteratively.
        % for each combination of num balls, and num bins
        % an arrangement would be computed
        arrangements_array  = cell (num_balls, num_bins);
        % a single ball can go to only one bin.
        % so for (1, M), the arrangements form an identity
        % matrix
        for m=1:num_bins
            arrangements_array{1, m} = eye(m);   
        end
        % if there is only one bin then all balls go there
        for n=1:num_balls
            arrangements_array{n, 1} = n;
        end
        % we now compute rest of the arrangements.
        for n=2:num_balls
            for m=2:num_bins
                % recurrence.
                % either the new bin was used or not used.
                % if the new bin is not used, then
                % it is equivalent to arrangements given by
                % (n, m-1).
                % if the new bin is used, then 
                % we start with configuration (n-1, m)
                % and see where the n-th ball will go.
                % note that all the arrangements where
                % n-th ball has been placed in previous
                % m-1 bins, are already covered.
                % so we have to consider only those
                % arrangements where the new ball goes
                % to the new bin.

                % We pick the arrangement for 
                % n-1 balls and m bins
                prev_bins_arrangement = arrangements_array{n, m-1};
                % we introduce the new empty bin at the beginning
                num_arrangements = size(prev_bins_arrangement, 1);
                prev_bins_arrangement = [zeros(num_arrangements, 1) prev_bins_arrangement];

                % We pick the arrangement for 
                % n-1 balls and m bins
                prev_balls_arrangement = arrangements_array{n-1, m};
                % now we have one more ball to put in the new bin
                prev_balls_arrangement(:, 1) = prev_balls_arrangement(:, 1) + 1;
                arrangements = [prev_balls_arrangement; prev_bins_arrangement];
                % finally place the result.
                arrangements_array{n, m}  = arrangements;
            end
        end
        % return the final arrangement
        arrangement = arrangements_array{end, end};
    end
end

end
