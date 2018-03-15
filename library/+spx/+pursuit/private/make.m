compstr = computer;
is64bit = strcmp(compstr(end-1:end),'64');


% compilation parameters

compile_params = cell(0);
if (is64bit)
  compile_params{end+1} = '-largeArrayDims';
end
compile_params{end+1} = '-lmwblas';
compile_params{end+1} = '-lmwlapack';


% Compile files %
sources = {'argcheck.c', 'spxblas.c', 'spxalg.c', 'omp.c'};
% ,'ompcore.c','omputils.c','myblas.c','ompprof.c'

% disp('Compiling ompmex...');
% mex('mex_omp.c', sources{:},compile_params{:});

% disp('Compiling mex_mult_mat_vec...');
% mex('mex_mult_mat_vec.c', sources{:},compile_params{:});

% disp('Compiling mex_mult_mat_t_vec...');
% mex('mex_mult_mat_t_vec.c', sources{:},compile_params{:});

% disp('Compiling mex_mult_mat_mat...');
% mex('mex_mult_mat_mat.c', sources{:},compile_params{:});

% disp('Compiling mex_mult_mat_t_mat...');
% mex('mex_mult_mat_t_mat.c', sources{:},compile_params{:});

% disp('Compiling mex_test_blas...');
% mex('mex_test_blas.c', sources{:},compile_params{:});

disp('Compiling mex_omp_chol...');
mex('mex_omp_chol.c', sources{:},compile_params{:});
