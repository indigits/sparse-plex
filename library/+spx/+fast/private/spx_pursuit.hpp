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
};


}
