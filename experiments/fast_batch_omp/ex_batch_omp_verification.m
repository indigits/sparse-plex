M = 512;
N = 1000;
K = 16;
S = 400;
Phi = spx.dict.simple.gaussian_mtx(M, N);
G = Phi' * Phi;
X = spx.data.synthetic.SparseSignalGenerator(N, K, S).gaussian;
Y = Phi * X;
X1 = omp(Phi,Y,[], K,'messages',4);
X2 =  spx.fast.batch_omp(Phi, Y, G, [], K, 0);
cmpare = spx.commons.SparseSignalsComparison(X1, X2, K);
cmpare.summarize();

DtY = Phi' * Y;
X3 = spx.fast.batch_omp([], [], G, DtY, K, 0);
cmpare = spx.commons.SparseSignalsComparison(X1, X3, K);
cmpare.summarize();

X4 = spx.pursuit.single.OrthogonalMatchingPursuit(Phi, K).solve_all_linsolve(Y).Z;
cmpare = spx.commons.SparseSignalsComparison(X1, X4, K);
cmpare.summarize();
