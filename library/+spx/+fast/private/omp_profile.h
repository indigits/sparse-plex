#ifndef _OMP_PROFILE_H_
#define _OMP_PROFILE_H_ 1

#include <time.h>

// Names of profiling steps
enum {
 TIME_DtD,
 TIME_DtR,
 TIME_MaxAbs,
 TIME_DictSubMatrixUpdate,
 TIME_GramSubMatrixUpdate,
 TIME_LCholUpdate,
 TIME_LLtSolve,
 TIME_LeastSquares,
 TIME_RUpdate,
 TIME_Beta,
 TIME_HUpdate,
 TIME_AtomRanking
};


typedef struct{
    clock_t begin_time;
    clock_t previous_time;
    clock_t dtd_time;
    clock_t dtr_time;
    clock_t max_abs_time;
    clock_t dict_submat_update_time;
    clock_t gram_submat_update_time;
    clock_t lchol_update_time;
    clock_t llt_solve_time;
    clock_t least_square_time;
    clock_t r_update_time;
    clock_t beta_time;
    clock_t h_update_time;
    clock_t atom_ranking_time;
} omp_profile;

void omp_profile_init(omp_profile* profile);
void omp_profile_tic(omp_profile* profile);
void omp_profile_toc(omp_profile* profile, int type);
void omp_profile_toctic(omp_profile* profile, int type);
void omp_profile_print(omp_profile* profile);

#endif
