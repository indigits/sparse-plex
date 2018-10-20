classdef runlength
% Functions related to run length encoding
% 
methods(Static)

    function encoding = encode(x)
        diff_positions = find(diff(x) ~= 0);
        runs = diff([0 diff_positions numel(x)]);
        start_positions  = [1 (diff_positions + 1)];
        symbols = x(start_positions);
        encoding = [symbols; runs];
        encoding = encoding(:)';
    end

    function x_dec = decode(encoding)
        x_dec = [];
        for i=1:numel(encoding) / 2
            symbol = encoding(i*2 -1);
            run_length = encoding(i*2);
            x_dec = [x_dec symbol * ones([1, run_length])];
        end
    end

end
end
