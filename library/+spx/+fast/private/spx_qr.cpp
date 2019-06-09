#include "spx_qr.hpp"

namespace spx{

namespace qr{

int reorth(const Matrix& Q, const index_vector& ind, Vec& r, double& r_norm, 
    double alpha, int method){
    // Number or rows in each column [length of r vector]
    int m = Q.rows();
    // Number of columns to orthogonalize against
    int n = Q.columns();
    if (m != r.length()){
        throw std::invalid_argument("The number of rows in Q is not same as length of r.");
    }
    // Number of vectors to be orthogonalized against
    int k = ind.size();
    //! indicate if orthogonalize against all columns
    bool simple = (k == n);
    // Number of reorthogonalizations
    int nre = 0;
    if (n == 0){
        // Nothing to do
        return nre;
    }
    if (k == 0 || m == 0){
        // Nothing to do
        return nre;
    }
    // Corrections made for each column in Q
    d_vector ss(k);
    Vec s(ss);
    // Old value of norm of r
    double normold = 0;
    // Temporary storages
    d_vector tt(k);
    Vec t(tt);
    d_vector qq(m);
    Vec q(qq);
    // Reorthogonalization loop
    while ((r_norm < alpha * normold) || nre == 0){
        if (method == 1){
            // CGS 
            if (simple){
                // t = Q' r projections of r on vectors in Q
                Q.mult_t_vec(r, t);
                // q = Q * t
                Q.mult_vec(t, q);
                // r = r - q
                r.add(q, -1);
            } else {
                // t = Q(:, ind)'*r
                Q.mult_t_vec(ind, r, t);
                // q = Q(:, ind) t
                Q.mult_vec(ind, t, q);
                // r = r - q
                r.add(q, -1);
            }
            // Accumulate updates 
            s.add(t);

        } else {
            // MGS
            for (int i=0; i < k; ++i){
                // t = Q(:, i)' * r
                size_t index = ind[i];
                Vec qq = Q.column_ref(index);
                double t = qq.inner_product(r);
                // r = r - t Q(:, i)
                r.add(qq, -t);
            }
        }
        // old norm
        normold = r_norm;
        // compute new value of norm of r
        r_norm = r.norm();
        // number of reorthogonalizations
        nre = nre + 1;
        if (nre > 4){
            // r is in span (Q) to full accuracy => accept r = 0
            r = 0;
            r_norm = 0;
            return nre;
        }
    }
}


}
}