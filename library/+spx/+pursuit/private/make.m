compstr = computer;
is64bit = strcmp(compstr(end-1:end),'64');


% compilation parameters

compile_params = cell(0);
if (is64bit)
  compile_params{end+1} = '-largeArrayDims';
end
compile_params{end+1} = '-lmwblas';


% Compile files %
sources = {'argcheck.c', 'spxblas.c'};
% ,'ompcore.c','omputils.c','myblas.c','ompprof.c'

disp('Compiling ompmex...');
mex('mex_omp.c', sources{:},compile_params{:});

disp('Compiling mex_mult_mat_vec...');
mex('mex_mult_mat_vec.c', sources{:},compile_params{:});

disp('Compiling mex_mult_mat_t_vec...');
mex('mex_mult_mat_t_vec.c', sources{:},compile_params{:});
