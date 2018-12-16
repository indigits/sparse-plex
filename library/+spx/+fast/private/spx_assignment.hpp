#ifndef _SPX_ASSIGNMENT_H_ 
#define _SPX_ASSIGNMENT_H_ 1

#include "spx_operator.hpp"

namespace spx {

/**
Implementation based on 
http://www.mathcs.emory.edu/~cheung/Courses/323/Syllabus/Matching/algorithm.html
*/

class BiPartiteMatching {
public:
    BiPartiteMatching(const Matrix& edges);
    ~BiPartiteMatching();
    void operator()();
    //! Best matches found from row to column
    inline const i_vector& r2c_matches() const {
        return m_y2x_matches;
    }
    //! Best matches found from column to row
    inline const i_vector& c2r_matches() const {
        return m_x2y_matches;
    }
    inline bool is_complete_match() const {
        return (m_num_matches == m_edges.rows());
    }
    inline const i_vector& x_labels() const {
        return m_x_labels;
    }
    inline const i_vector& y_labels() const {
        return m_y_labels;
    }
    void set_verbose(VERBOSITY verbose){
        m_verbose = verbose;
    }
    VERBOSITY get_verbose() const {
        return m_verbose;
    }
private:
    bool find_alternate_path();
    const Matrix& m_edges;
    //! matches from col to row r = match[c]
    i_vector m_x2y_matches;
    //! matches from rows to cols c = match[r]
    i_vector m_y2x_matches;
    //! Number of matches
    int m_num_matches;
    //! space for storing labels for x nodes
    i_vector m_x_labels;
    //! space for storing labels for y nodes
    i_vector m_y_labels;
    //! The x node from which labeling starts
    int m_x_star;
    //! Verbosity level
    VERBOSITY m_verbose;
private:
    inline void update_matching(int x, int y) {
        int old_y = m_x2y_matches[x];
        int old_x = m_y2x_matches[y];
        if (old_y == y) {
            // This is an existing match
            return;
        }
        // We are introducing a new match
        m_x2y_matches[x] = y;
        m_y2x_matches[y] = x;
        ++m_num_matches;
        // if (old_x < 0 && old_y < 0) {
        // }
        if (old_x >= 0) {
            // We removed an old match from x to y
            m_x2y_matches[old_x] = -1;
            --m_num_matches;
        }
        if (old_y >= 0) {
            // We removed an old match from y to x
            m_y2x_matches[old_y] = -1;
            --m_num_matches;
        }
    }
    inline void remove_matching(int x, int y) {
            m_x2y_matches[x] = -1;
            m_y2x_matches[y] = -1;
            --m_num_matches;
    }
};

class HungarianAssignment{
public:
    HungarianAssignment(const Matrix& cost);
    ~HungarianAssignment();
    //! Computes and returns the optimal assignment
    d_vector operator()();
    void set_verbose(VERBOSITY verbose){
        m_verbose = verbose;
        m_bpm.set_verbose(verbose);
    }
    VERBOSITY get_verbose() const {
        return m_verbose;
    }
    //! Returns the best cost as per the best matching
    double best_cost() const;
private:
    const Matrix& m_orig_cost;
    Matrix m_cost;
    //! Space to track zero locations
    Matrix m_zero_locations;
    //! Helper algorithm for matching
    BiPartiteMatching m_bpm;
    //! Verbosity level
    VERBOSITY m_verbose;
private:
    void add_next_best_cost_edges();
};

 
}

#endif // _SPX_ASSIGNMENT_H_ 