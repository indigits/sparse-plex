function make()

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
blas_sources  = {'argcheck.c', 'spxblas.c'};
common_sources = {'argcheck.c', 'spxblas.c', 'spxalg.c'};
omp_sources = [common_sources, 'omp.c', 'omp_util.c'];
batch_omp_sources = [common_sources, 'batch_omp.c', 'omp_util.c'];
batch_omp_spr_sources = [common_sources, 'batch_omp_spr.c', 'omp_util.c', 'omp_profile.c'];
omp_spr_sources = [common_sources, 'omp_spr.c', 'omp_util.c'];
batch_flipped_omp_spr_sources = [common_sources, 'batch_flipped_omp_spr.c', 'omp_util.c', 'omp_profile.c'];

make_program('mex_mult_mat_vec.c', blas_sources,compile_params);
make_program('mex_mult_mat_t_vec.c', blas_sources, compile_params);
make_program('mex_mult_mat_mat.c', blas_sources, compile_params);
make_program('mex_mult_mat_t_mat.c', blas_sources, compile_params);
make_program('mex_test_blas.c', blas_sources,compile_params);

make_program('mex_omp_chol.c', omp_sources,compile_params);
make_program('mex_batch_omp.c', batch_omp_sources,compile_params);
make_program('mex_batch_omp_spr.c', batch_omp_spr_sources,compile_params);
make_program('mex_omp_spr.c', omp_spr_sources,compile_params);
make_program('mex_batch_flipped_omp_spr.c', batch_flipped_omp_spr_sources,compile_params);
end

function make_program(mex_src_file, other_source_files, compile_params)
    mex_target_file = strrep(mex_src_file, '.c' , '.mexw64');
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
