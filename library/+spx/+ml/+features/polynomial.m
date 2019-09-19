function PhiX = polynomial(X, degree, varargin)
    params = inputParser;
    params.addRequired('X');
    params.addRequired('degree');
    params.addParameter('bias', true);
    params.parse(X, degree, varargin{:});
    results = params.Results;
    bias = results.bias;
    [rows, dim] = size(X);
    if bias
        num_features = 1;
    else
        num_features = 0;
    end
    for deg=1:degree
        num_features = num_features + nchoosek(dim+deg-1, deg);
    end
    PhiX = zeros(rows, num_features);
    if bias
        PhiX(:, 1) = 1;
    end
    for r=1:rows
        x = X(r, :);
        if bias
            s = 2;
        else
            s = 1;
        end
        for deg=1:degree
            num_features = nchoosek(dim+deg-1, deg);
            e = s + num_features -1;
            % form all k degree combinations
            combs = spx.discrete.combinations_with_replacement(x, deg);
            features = prod(combs, 2)';
            PhiX(r, s:e) = features;
            s = s + num_features;
        end
    end
end

