/**
Matching pursuit
*/

#include "spx_operator.hpp"

namespace spx {

class MatchingPursuit {
public: 
    MatchingPursuit(const Operator& dict);
    ~MatchingPursuit();
    void operator()(const d_vector& x);
    void operator()(const double x[]);
    void set_max_iterations(mwIndex max_iterations){
        m_max_iterations = max_iterations;
    }
    mwIndex get_max_iterations() const {
        return m_max_iterations;
    }
    void set_max_residual_norm(double max_residual_norm) {
        m_max_residual_norm = max_residual_norm;
    }
    double get_max_residual_norm() const {
        return m_max_residual_norm;
    }
    const d_vector& get_representation() const {
        return m_z;
    }
    const d_vector& get_residual() const {
        return m_r;
    }
    const mwIndex& get_iterations() const {
        return m_iterations;
    }
    void set_verbose(VERBOSITY verbose){
        m_verbose = verbose;
    }
    VERBOSITY get_verbose() const {
        return m_verbose;
    }
private:
    const Operator& m_dict;
    //! representation vector
    d_vector m_z;
    //! correlation vector
    d_vector m_h;
    //! residual vector
    d_vector m_r;
    //! maximum number of iterations
    mwIndex m_max_iterations;
    //! maximum allowed residual norm
    double m_max_residual_norm;
    //! actual number of iterations
    mwIndex m_iterations;
    //! maximum ratio between residual and signal norm
    double m_max_res_norm_ratio;
    //! Verbosity level
    VERBOSITY m_verbose;
};

class CoSaMP {
public: 
    CoSaMP(const Operator& dict, mwIndex m_sparsity);
    ~CoSaMP();
    void operator()(const d_vector& x);
    void operator()(const double x[]);
    void set_max_iterations(mwIndex max_iterations){
        m_max_iterations = max_iterations;
    }
    mwIndex get_max_iterations() const {
        return m_max_iterations;
    }
    void set_max_residual_norm(double max_residual_norm) {
        m_max_residual_norm = max_residual_norm;
    }
    double get_max_residual_norm() const {
        return m_max_residual_norm;
    }
    const d_vector& get_representation() const {
        return m_representation;
    }
    const d_vector& get_residual() const {
        return m_residual;
    }
    const mwIndex& get_iterations() const {
        return m_iterations;
    }
    void set_verbose(VERBOSITY verbose){
        m_verbose = verbose;
    }
    VERBOSITY get_verbose() const {
        return m_verbose;
    }
private:
    //! Dictionary
    const Operator& m_dict;
    //! Sparsity level
    mwIndex m_sparsity;
    //! signal to be solved for
    const double* m_signal;
    //! Result representation vector
    d_vector m_representation;
    //! correlation vector
    d_vector m_h;
    //! absolute correlation vector
    d_vector m_abs_h;
    //! residual vector
    d_vector m_residual;
    //! approximation vector
    d_vector m_approximation;
    //! maximum number of iterations
    mwIndex m_max_iterations;
    //! maximum allowed residual norm
    double m_max_residual_norm;


    //! Space for holding up to 3K indices;
    index_vector m_largest_3k_indices;
    //! Space for holding up to K indices;
    index_vector m_largest_k_indices;
private:
    // Variables for least squares step
    //! Space for Gram matrix for sub-matrix
    d_vector m_sub_gram_space;
    //! Space for sub_phi' x vector
    d_vector m_sub_phi_t_x;
    //! Least square solution
    d_vector m_z_3k;
private:
    /// Variables for pruning step
    d_vector m_z_3k_sqr;
    // k values of z
    d_vector m_z_k;
    index_vector m_sorted_3k;
private:
    // Algorithm control variables
    //! actual number of iterations
    mwIndex m_iterations;
    //! maximum ratio between residual and signal norm
    double m_max_res_norm_ratio;
    //! sub-matrix of up to 3K columns
    Matrix m_sub_phi;
    //! Verbosity level
    VERBOSITY m_verbose;
private:
    //! tracking data
    d_vector m_res_norm_sqrs;
private:
    void match();
    void identify_3k();
    void least_square();
    void prune_k();
    void update_approximation();
    double update_residual();
    void prepare_representation();
};


}
