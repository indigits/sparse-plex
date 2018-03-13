classdef chol

methods(Static)

    function L_new = chol_update(L, atom)
        n = size(L, 1);
        if n == 0
            L_new = sqrt(atom);
            return;
        end
        v = atom(1:end-1);
        c = atom(end);
        opts.LT = true;
        w = linsolve(L, v, opts);
        c_new = sqrt(c - w' * w);
        L_new = [L zeros(n, 1); w' c_new];
    end
end
end
