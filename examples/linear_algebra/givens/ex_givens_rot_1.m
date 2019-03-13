function ex_givens_rot_1()
clc;
close all;

test_ab(3, 4);
test_ab(4, 3);

test_ab(3, -4);
test_ab(4, -3);

test_ab(-3, 4);
test_ab(-4, 3);

test_ab(-3, -4);
test_ab(-4, -3);

end

function test_ab(a, b)
    x = [a;b];
    [c, s] = spx.la.givens.rotation(a,b);
    G1 = [c s; -s c];
    theta = rad2deg(spx.la.givens.theta(c,s));
    G2 = planerot([a;b]);
    y1 = G1' * x;
    y2 = G2 * x;
    fprintf('x: %d %d,\t\ty1: %.0f %.0f,\t\ty2: %.0f %.0f\n', a, b, ...
        y1(1), y1(2), y2(1), y2(2));
end

