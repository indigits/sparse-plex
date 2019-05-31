function A = mat_simple1_1(n)
rng default;
m = 200;
if nargin < 1
    n = 50;
end
U0 = orth(randn(m));
V0 = orth(randn(n));
S0 = zeros(m, n);
for i=1:n
    S0(i,i) = m / (i);
end
A = U0*S0*V0';

end