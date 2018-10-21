classdef synthetic
methods(Static)

function x = simple(L)
a0 = [0,  1, 40,  1,   0, -34, 118, -99,   0,   2,  21,   2,   0,   0,   0];
d0 = [0, 27, 59, 91, 131, 141, 163, 185, 195, 275, 307, 339, 357, 390, 440];
a = a0 / max(a0);
d = round(d0 * L / d0(15));
d(15) = L;
for i = 1:14
    m = d(i) : d(i+1) - 1;
    slope = (a(i+1) - a(i)) / (d(i+1) - d(i));
    x(m+1) = a(i) + slope * (m - d(i));
end
end

function x = simple_multiple(L, count)
    if nargin < 2
        count  = 5;
    end
    if nargin < 1
        L = 500;
    end
    x0 = spx.ecg.synthetic.simple(L);
    x = kron(ones(1,count),x0);
end

end
end
