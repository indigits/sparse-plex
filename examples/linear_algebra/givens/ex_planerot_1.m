clc;
x = [3 ; 4];
G1 = planerot(x);
G2 = spx.la.givens.planerot(x);
fprintf('%.2f %.2f: %.2f %.2f, %.2f %.2f', ...
    x(1), x(2), G1(1,1), G1(2,1), G2(1,1), G2(2,1));
fprintf('::: %d\n', max(max(abs(G1-G2))) > 1e-4);

x = [4 ; 3];
G1 = planerot(x);
G2 = spx.la.givens.planerot(x);
fprintf('%.2f %.2f: %.2f %.2f, %.2f %.2f', ...
    x(1), x(2), G1(1,1), G1(2,1), G2(1,1), G2(2,1));
fprintf('::: %d\n', max(max(abs(G1-G2))) > 1e-4);

x = [1 ; 1];
G1 = planerot(x);
G2 = spx.la.givens.planerot(x);
fprintf('%.2f %.2f: %.2f %.2f, %.2f %.2f', ...
    x(1), x(2), G1(1,1), G1(2,1), G2(1,1), G2(2,1));
fprintf('::: %d\n', max(max(abs(G1-G2))) > 1e-4);


x = [-3 ; 4];
G1 = planerot(x);
G2 = spx.la.givens.planerot(x);
fprintf('%.2f %.2f: %.2f %.2f, %.2f %.2f', ...
    x(1), x(2), G1(1,1), G1(2,1), G2(1,1), G2(2,1));
fprintf('::: %d\n', max(max(abs(G1-G2))) > 1e-4);


x = [3 ; -4];
G1 = planerot(x);
G2 = spx.la.givens.planerot(x);
fprintf('%.2f %.2f: %.2f %.2f, %.2f %.2f', ...
    x(1), x(2), G1(1,1), G1(2,1), G2(1,1), G2(2,1));
fprintf('::: %d\n', max(max(abs(G1-G2))) > 1e-4);

x = [4 ; -3];
G1 = planerot(x);
G2 = spx.la.givens.planerot(x);
fprintf('%.2f %.2f: %.2f %.2f, %.2f %.2f', ...
    x(1), x(2), G1(1,1), G1(2,1), G2(1,1), G2(2,1));
fprintf('::: %d\n', max(max(abs(G1-G2))) > 1e-4);

x = [-3 ; -4];
G1 = planerot(x);
G2 = spx.la.givens.planerot(x);
fprintf('%.2f %.2f: %.2f %.2f, %.2f %.2f', ...
    x(1), x(2), G1(1,1), G1(2,1), G2(1,1), G2(2,1));
fprintf('::: %d\n', max(max(abs(G1-G2))) > 1e-4);

x = [-4 ; -3];
G1 = planerot(x);
G2 = spx.la.givens.planerot(x);
fprintf('%.2f %.2f: %.2f %.2f, %.2f %.2f', ...
    x(1), x(2), G1(1,1), G1(2,1), G2(1,1), G2(2,1));
fprintf('::: %d\n', max(max(abs(G1-G2))) > 1e-4);

