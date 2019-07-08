function make(arg1)

options.clean = false;
options.filepath = [];
if nargin >= 1
    if endsWith(arg1, '.cpp') | endsWith(arg1, '.c')
        options.filepath = arg1;
    end
    if strcmp(arg1, 'clean')
        options.clean = true;
    end
end

compstr = computer;
is64bit = strcmp(compstr(end-1:end),'64');


% compilation parameters

compile_params = cell(0);
if (is64bit)
  compile_params{end+1} = '-largeArrayDims';
end
compile_params{end+1} = '-lmwblas';
compile_params{end+1} = '-lmwlapack';

cpp_compile_params = cell(0);
if (is64bit)
  cpp_compile_params{end+1} = '-largeArrayDims';
end


% Compile files %

blas_sources  = {'argcheck.c', 'spxblas.c'};
common_sources = {'argcheck.c', 'spxblas.c', 'spxla.c', 'spxalg.c'};
common_cpp_sources = {'argcheck.c', 'spxblas.c', 'spxla.c', 'spxalg.c', 'spx_operator.cpp', 'spx_pursuit.cpp', 'spx_vector.cpp', 'spx_matarr.cpp'};
% Simple matrix multiplication routines
make_program('mex_mult_mat_vec.c', blas_sources,compile_params, options);
make_program('mex_mult_mat_t_vec.c', blas_sources, compile_params, options);
make_program('mex_mult_mat_mat.c', blas_sources, compile_params, options);
make_program('mex_mult_mat_t_mat.c', blas_sources, compile_params, options);
make_program('mex_test_blas.c', blas_sources,compile_params, options);
make_program('mex_sparse_demo.cpp', common_cpp_sources,cpp_compile_params, options);
make_program('mex_demo_func_handle.cpp', common_cpp_sources,cpp_compile_params, options);

% Routine for solving a linear equation
la_sources = {'argcheck.c', 'spxblas.c', 'spxla.c'};
make_program('mex_linsolve.c', la_sources, compile_params, options);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Searching, Sorting, Selection algorithms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% quick select algorithm
quickselect_sources = {'argcheck.c', 'spxalg.c'};
make_program('mex_quickselect.c', quickselect_sources, compile_params, options);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Optimization algorithms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Conjugate Gradient
cg_sources = [common_cpp_sources, 'spx_cg.cpp'];
make_program('mex_cg.cpp', cg_sources,cpp_compile_params, options);

% Hungarian assignment
hungarian_sources = [common_cpp_sources, 'spx_assignment.cpp'];
make_program('mex_hungarian.cpp', hungarian_sources, cpp_compile_params, options);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Matching Pursuit Algorithms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Matching Pursuit
mp_sources = [common_cpp_sources, 'spx_matching_pursuit.cpp'];
make_program('mex_mp.cpp', mp_sources,cpp_compile_params, options);
% Compressive Sampling Matching Pursuit
cosamp_sources = [common_cpp_sources, 'spx_cosamp.cpp', 'spx_cg.cpp'];
make_program('mex_cosamp.cpp', cosamp_sources,cpp_compile_params, options);

% Orthogonal Matching Pursuit
omp_sources = [common_sources, 'omp.c', 'omp_util.c', 'omp_profile.c'];
make_program('mex_omp_chol.c', omp_sources,compile_params, options);

omp_ar_sources = [common_sources, 'omp_ar.c', 'omp_util.c', 'omp_profile.c'];
make_program('mex_omp_ar.c', omp_ar_sources,compile_params, options);

batch_omp_sources = [common_sources, 'batch_omp.c', 'omp_util.c'];
make_program('mex_batch_omp.c', batch_omp_sources,compile_params, options);

omp_spr_sources = [common_sources, 'omp_spr.c', 'omp_util.c'];
make_program('mex_omp_spr.c', omp_spr_sources,compile_params, options);

batch_omp_spr_sources = [common_sources, 'batch_omp_spr.c', 'omp_util.c', 'omp_profile.c'];
make_program('mex_batch_omp_spr.c', batch_omp_spr_sources,compile_params, options);

batch_flipped_omp_spr_sources = [common_sources, 'batch_flipped_omp_spr.c', 'omp_util.c', 'omp_profile.c'];
make_program('mex_batch_flipped_omp_spr.c', batch_flipped_omp_spr_sources,compile_params, options);

% Generalized Orthogonal Matching Pursuit
gomp_sources = [common_sources, 'gomp.c', 'omp_util.c', 'omp_profile.c'];
make_program('mex_gomp.c', gomp_sources,compile_params, options);

% GOMP MMV
gomp_mmv_sources = [common_sources, 'gomp_mmv.c', 'omp_util.c', 'omp_profile.c'];
make_program('mex_gomp_mmv.c', gomp_mmv_sources,compile_params, options);

% GOMP for SPR
gomp_spr_sources = [common_sources, 'gomp_spr.c', 'omp_util.c', 'omp_profile.c'];
make_program('mex_gomp_spr.c', gomp_spr_sources,compile_params, options);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Singular Value Problems
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% eigen value composition
make_program('mex_sqrt_times.cpp', common_cpp_sources, cpp_compile_params, options);

% BDSQR for bidiagonal matrices.
bdsqr_sources = [common_cpp_sources, 'spx_svd.cpp'];
make_program('mex_bdsqr.cpp', bdsqr_sources, cpp_compile_params, options);
make_program('mex_svd_bd_hizsqr.cpp', bdsqr_sources, cpp_compile_params, options);

% Lanczos Bidiagonalization and Partial Reorthogonalization
lansvd_sources = [common_cpp_sources, 'spx_lanbd.cpp', 'spx_lansvd.cpp', 'spx_rand.cpp', 'spx_qr.cpp', 'spx_svd.cpp'];
make_program('mex_lansvd.cpp', lansvd_sources, cpp_compile_params, options);

end

function make_program(mex_src_file, other_source_files, compile_params, options)
    filepath = options.filepath;
    clean = options.clean;
    if filepath & ~strcmp(mex_src_file, filepath)
        % Only a single file to be built
        return;
    end
    [~, mex_scr_name, extn] = fileparts(mex_src_file);
    mex_target_file =  [mex_scr_name '.mexw64'];
    if clean
        if exist(mex_target_file)
            fprintf('Deleting: %s\n', mex_target_file);
            delete(mex_target_file);
        end
        return;
    end
    build_mex = false;
    if 0 == exist(mex_target_file)
        build_mex = true;
    else
        d = dir(mex_target_file);
        target_mod_time = d.datenum;
        if 0 == exist(mex_src_file)
            error('File: %s does not exist\n', mex_src_file);
        end
        d  = dir(mex_src_file);
        src_mod_time = d.datenum;
        if src_mod_time > target_mod_time
            build_mex = true;
        end
        n = numel(other_source_files);
        for i=1:n
            src_file = other_source_files{i};
            if 0 == exist(src_file)
                error('File: %s does not exist.\n', src_file);
            end
            d = dir(src_file);
            src_mod_time = d.datenum;
            if (src_mod_time > target_mod_time)
                build_mex = true;
            end
        end
    end
    if build_mex
        fprintf('Compiling: %s\n', mex_src_file);
        mex(mex_src_file, other_source_files{:}, compile_params{:});
    else
        fprintf('File: %s is already up to date.\n', mex_target_file);
    end
end
