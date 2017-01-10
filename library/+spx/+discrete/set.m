classdef set

methods(Static)
    function subset = random_subset_1(set_size, subset_size)
        subset = randperm(set_size, subset_size);
    end


    function subset = random_subset_2(set_size, subset_size)
        flags = zeros(1, set_size);
        if (subset_size == 0)
            subset = [];
        end
        n = set_size;
        m = subset_size;
        % we will iterate m times
        for i=n-m+1 : n
            % pick an entry between 1:i to be selected.
            % note that i is never yet selected.
            j = ceil(i * rand());
            if (flags(j) == 0)
                % if the entry is not already selected, pick it
                flags(j) =1 ;
            else
                % otherwise select the i-th entry
                flags(i) = 1;
            end
        end
        subset = find (flags == 1);
    end

end
end
