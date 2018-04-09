#include "mex.h"
#include "omp_profile.h"


void omp_profile_init(omp_profile* profile){
    profile->previous_time = 0;
    profile->dtd_time = 0;
    profile->dtr_time = 0;
    profile->max_abs_time = 0;
    profile->dict_submat_update_time = 0;
    profile->gram_submat_update_time  = 0;
    profile->lchol_update_time = 0;
    profile->llt_solve_time = 0;
    profile->beta_time = 0;
    profile->h_update_time = 0;
    profile->r_update_time = 0;
    profile->atom_ranking_time = 0;

    profile->begin_time = clock();
    omp_profile_tic(profile);
}

void omp_profile_tic(omp_profile* profile){
  profile->previous_time = clock();
}

void omp_profile_toc(omp_profile* profile, int type){
    clock_t spent_time = clock() - profile->previous_time;
    switch(type){
        case TIME_DtD: 
            profile->dtd_time += spent_time;
            break;
        case TIME_DtR: 
            profile->dtr_time += spent_time;
            break;
        case TIME_MaxAbs: 
            profile->max_abs_time += spent_time;
            break;
        case TIME_DictSubMatrixUpdate: 
            profile->dict_submat_update_time += spent_time;
            break;
        case TIME_GramSubMatrixUpdate: 
            profile->gram_submat_update_time += spent_time;
            break;
        case TIME_LCholUpdate: 
            profile->lchol_update_time += spent_time;
            break;
        case TIME_LLtSolve: 
            profile->llt_solve_time += spent_time;
            break;
        case TIME_RUpdate: 
            profile->r_update_time += spent_time;
            break;
        case TIME_Beta: 
            profile->beta_time += spent_time;
            break;
        case TIME_HUpdate: 
            profile->h_update_time += spent_time;
            break;
        case TIME_AtomRanking: 
            profile->atom_ranking_time += spent_time;
            break;
        default:
            break;
    }
}

void omp_profile_toctic(omp_profile* profile, int type){
    omp_profile_toc(profile, type);
    omp_profile_tic(profile);
}

void omp_profile_print_help(const char* step, 
    clock_t spent_time, clock_t total_time){
    if (spent_time > 0){
        double seconds = spent_time / (double)CLOCKS_PER_SEC;
        double percent  = spent_time * (double)100 / total_time;
        mexPrintf("%s time: %.3f seconds, %.2f %%\n", step, seconds, percent);
    }
}

void omp_profile_print(omp_profile* profile){
    clock_t total_time;
    total_time = clock() - profile->begin_time;
    mexPrintf("\nProfile information. Total time spent: %.2f seconds\n", total_time / (double)CLOCKS_PER_SEC);
    omp_profile_print_help("dtd", profile->dtd_time, total_time);
    omp_profile_print_help("dtr", profile->dtr_time, total_time);
    omp_profile_print_help("max_abs", profile->max_abs_time, total_time);
    omp_profile_print_help("SubD update", profile->gram_submat_update_time, total_time);
    omp_profile_print_help("SubG update", profile->gram_submat_update_time, total_time);
    omp_profile_print_help("L update", profile->lchol_update_time, total_time);
    omp_profile_print_help("L solve", profile->llt_solve_time, total_time);
    omp_profile_print_help("R update", profile->r_update_time, total_time);
    omp_profile_print_help("Beta", profile->beta_time, total_time);
    omp_profile_print_help("H update", profile->h_update_time, total_time);
    omp_profile_print_help("atom ranking", profile->atom_ranking_time, total_time);
    mexPrintf("\n");
}
