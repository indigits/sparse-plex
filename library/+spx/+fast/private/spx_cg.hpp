/**
Conjugate gradients solver
*/

#include "spx_operator.hpp"
#include <time.h>

namespace spx {


/**
Conjugate gradients algorithm

Mapping of variables from cgsolve.m

x -> x
r -> r
q -> w
d -> p
delta -> res_norm_sqr
alpha -> alpha
beta -> 


*/

class CGProfile {
public:
    CGProfile() ;
    ~CGProfile();
public:
    inline void reset() {
        begin_time = clock();
        tic();
    }
    inline void tic() {
        previous_time = clock();
    }
    inline clock_t toc() const {
        return clock() - previous_time;
    }
    inline clock_t toctic() {
        clock_t spent =  clock() - previous_time;
        tic();
        return spent;     
    }
    inline void log_total_time() {
        total_time = clock() - begin_time;
    }
    inline void log_w_update() {
        w_update_time += toctic();
    }
    inline void log_x_update() {
        x_update_time += toctic();
    }
    inline void log_r_update() {
        r_update_time += toctic();
    }
    inline void log_p_update() {
        p_update_time += toctic();
    }
    inline void log_best_x_update() {
        best_x_update_time += toctic();
    }
    void print() const;
private:
    clock_t begin_time;
    clock_t previous_time;
    clock_t total_time;

    clock_t w_update_time;
    clock_t x_update_time;
    clock_t r_update_time;
    clock_t p_update_time;
    clock_t best_x_update_time;
private:
    void print_step(const char* step, clock_t spent_time) const;
};


class CongugateGradients{
public: 
    CongugateGradients(const Operator& op);
    ~CongugateGradients();
    void operator()(const double b[]);
public: // Results
    const d_vector& get_x() const {
        return m_x;
    }
    const mwIndex& get_iterations() const {
        return m_iterations;
    }
public: // Parameter setters
    void set_max_iterations(mwIndex max_iterations){
        m_max_iterations = max_iterations;
    }
    mwIndex get_max_iterations() const {
        return m_max_iterations;
    }
    void set_tolerance(double tolerance) {
        m_tolerance = tolerance;
    }
    double get_tolerance() const {
        return m_tolerance;
    }
    void set_verbose(mwIndex verbose){
        m_verbose = verbose;
    }
    mwIndex get_verbose() const {
        return m_verbose;
    }
private:
    const Operator& m_op;
    double m_tolerance;
    //! maximum number of iterations
    mwIndex m_max_iterations;
    //! actual number of iterations
    mwIndex m_iterations;
    int m_verbose;
    //! Result
    d_vector m_x;
    //! Residual
    d_vector m_r;
    d_vector m_w;
    d_vector m_p;
    d_vector m_best_x;
    CGProfile m_profile;
};



}
