#include "spx_assignment.hpp"
#include <limits>
namespace spx {

/************************************************
 *  BiPartiteMatching Implementation
 ************************************************/
BiPartiteMatching::BiPartiteMatching(const Matrix& edges):
m_edges(edges),
m_num_matches(0)
{

}

BiPartiteMatching::~BiPartiteMatching(){

}
void BiPartiteMatching::operator()() {
    // Initialize matchings to empty
    m_x2y_matches.assign(m_edges.rows(), -1);
    m_y2x_matches.assign(m_edges.rows(), -1);
    m_num_matches = 0;
    // Setup an initial matching
    int y = 0;
    int n = m_edges.rows();
    for (int x = 0; x < n; ++x){
        if (m_edges(y, x) > 0){
            // We find a matching
            update_matching(x, y);
            break;
        }
    }
    while (m_num_matches < n){
        bool breakthrough = find_alternate_path();
        if (!breakthrough) {
            break;
        }
    }
}

/*
We are matching between rows and columns
X are columns 
Y are rows
*/
bool BiPartiteMatching::find_alternate_path() {
    // number of nodes on each side of the graph
    mwSize n = m_edges.rows();
    int x;
    // Find an X node which is unmatched yet.
    bool breakthrough = false;
    for (x = 0 ; x < n; ++x){
        if (m_x2y_matches[x] >= 0){
            continue;
        }
        // We found an unmatched node
        m_x_star = x;

        // initialize labels to unlabeled values
        i_vector& x_labels = m_x_labels;
        i_vector& y_labels = m_y_labels;
        y_labels.assign(n, -1);
        x_labels.assign(n, -1);
        //! indicates if a y node is labeled
        auto is_labeled_y = [&y_labels](int y) -> bool
        {
            return y_labels[y] >= 0;
        };
        //! indicates if an x node is labeled
        auto is_labeled_x = [&x_labels](int x) -> bool
        {
            return x_labels[x] >= 0;
        };
        //! add a label to an x node
        auto set_x_label = [&x_labels](int x, int y) -> void {
            x_labels[x] = y;
        };
        //! add a label to a y node
        auto set_y_label = [&y_labels](int y, int x) -> void {
            y_labels[y] = x;
        };
        // Assign label * to this column
        set_x_label(x, n);
        while (true) {
            // odd edge label algorithm
            int num_updated_ys = 0;
            // iterate over x nodes
            for (int x = 0; x < n; ++x){
                // ignore unlabeled x nodes
                if (!is_labeled_x(x)){
                    continue;
                }
                // iterate over its edges to y nodes
                for (int y = 0; y < n; ++y) {
                    if(!m_edges(y, x)) {
                        // no edge from x to y
                        continue;
                    }
                    if (m_x2y_matches[x] == y) {
                        // This edge is already matched
                        continue;
                    }
                    if (is_labeled_y(y)) {
                        // This y is already labeled
                        continue;
                    }
                    // label this y with this x
                    set_y_label(y, x);
                    ++num_updated_ys;
                }
                // proceed to look for next unlabeled y
            }
            if (m_verbose >= DEBUG_HUGE) {
                mexPrintf("Odd edge labeling: Updated ys: %d\n", num_updated_ys);
                print_i_vec(y_labels, "y_labels");
            }
            if (num_updated_ys == 0){
                // No changes happened i.e. no new y was labeled
                break;
            }
            // even edge label algorithm
            int num_updated_xs = 0;
            // iterate over y nodes
            for (int y = 0; y < n; ++y){
                // look for labeled y
                if (!is_labeled_y(y)){
                    continue;
                }
                int x = m_y2x_matches[y];
                if (x < 0) {
                    // No matched edge
                    continue;
                }
                if(is_labeled_x(x)) {
                    // This neighbor is already labeled
                    continue;
                }
                // label this neighbor with y
                set_x_label(x, y);
                ++num_updated_xs;
                // proceed to look for next y
            }
            if(m_verbose >= DEBUG_HUGE) {
                mexPrintf("Even edge labeling: Updated xs: %d\n", num_updated_xs);
                print_i_vec(x_labels, "x_labels");
            }
            if (num_updated_xs == 0){
                // No changes happened i.e. no new y was labeled
                break;
            }
        }
        // Time for breakthrough test
        for (int y =0; y < n; ++y) {
            if (is_labeled_y(y) && m_y2x_matches[y] < 0) {
                // We have found a breakthrough
                breakthrough = true;
                while (true) {
                    // We trace the edges backwards.
                    int x = y_labels[y];
                    update_matching(x, y);
                    y = x_labels[x];
                    if (y >= n || y < 0){
                        break;
                    }
                    //remove_matching(x, y);
                }
                break;
            }
        }
        // One perfect path has been found
        if(m_verbose >= DEBUG_HUGE) {
            print_i_vec(m_x2y_matches, "x2y_matches");
        }
        if (breakthrough == true) {
            return breakthrough;
        }
    }
    // No breakthrough
    return false;
}


/************************************************
 *  HungarianAssignment Implementation
 ************************************************/


HungarianAssignment::HungarianAssignment(
    const Matrix& cost):m_orig_cost(cost), 
m_cost(m_orig_cost.rows(), m_orig_cost.columns()),
m_zero_locations(m_orig_cost.rows(), m_orig_cost.columns()),
m_bpm(m_zero_locations){

}

HungarianAssignment::~HungarianAssignment(){

}

/**
X are columns
Y are rows
*/
d_vector HungarianAssignment::operator()(){
    // Copy the cost
    m_orig_cost.copy_matrix_to(m_cost);
    d_vector t(m_orig_cost.rows());
    if(m_verbose >= DEBUG_HIGH) {
        m_cost.print_int_matrix();
    }
    //! subtract all the minimal cost edges from each column [for each X]
    m_cost.subtract_col_mins_from_cols();
    //m_cost.print_int_matrix();
    //! subtract all the minimal cost edges from each row [for each Y]
    m_cost.subtract_row_mins_from_rows();
    //m_cost.print_int_matrix();
    //! identify zero locations and form the best cost edges subgraph
    m_cost.find_value(0, m_zero_locations);
    if (m_verbose >= DEBUG_HIGH){
        m_zero_locations.print_int_matrix();
    }
    // Find the maximal matching for this subgraph
    m_bpm();
    int max_iters = 100;
    if (m_cost.rows() > max_iters){
        max_iters = 2 * m_cost.rows();
    }
    int iter = 1;
    while (!m_bpm.is_complete_match() && iter < max_iters) {
        ++iter;
        // we will add the next best cost edges to our zero locations subgraph
        add_next_best_cost_edges();
        if (m_verbose >= DEBUG_HIGH){
            m_cost.print_int_matrix();
        }
        // Update zero locations
        m_cost.find_value(0, m_zero_locations);
        if (m_verbose >= DEBUG_HIGH){
            m_zero_locations.print_int_matrix();
        }
        // Find the maximal matching for this subgraph
        m_bpm();
    }
    const i_vector& res =  m_bpm.c2r_matches();
    for (int i=0; i < m_cost.columns(); ++i) {
        t[i] = res[i] + 1;

    }
    return t;
}

void HungarianAssignment::add_next_best_cost_edges() {
    const i_vector& x_labels = m_bpm.x_labels();
    const i_vector& y_labels = m_bpm.y_labels();
    double min_val = std::numeric_limits<double>::max();
    int n = m_cost.columns();
    for (int x = 0; x < n; ++x) {
        // Find labeled x
        if (x_labels[x] < 0) {
            continue;
        }
        // Find unlabeled y
        for (int y = 0; y < n; ++y) {
            if (y_labels[y] >= 0) {
                continue;
            }
            double cur_val = m_cost(y, x);
            if (min_val > cur_val) {
                min_val = cur_val;
            }
        }
    }
    // We have found the minimum value
    for (int x = 0; x < n; ++x) {
        // Find labeled x
        if (x_labels[x] < 0) {
            // Find unlabeled y
            for (int y = 0; y < n; ++y) {
                if (y_labels[y] < 0) {
                    continue;
                }
                // Add it for unlabeled X to labeled Y
                double cur_val = m_cost(y, x);
                if (cur_val > 0) {
                    m_cost(y, x) = cur_val + min_val;
                }
            }
        }
        else {
            // Find unlabeled y
            for (int y = 0; y < n; ++y) {
                if (y_labels[y] >= 0) {
                    continue;
                }
                // Subtract it for labeled X to unlabeled Y
                double cur_val = m_cost(y, x);
                if (cur_val > 0) {
                    m_cost(y, x) = cur_val - min_val;
                }
            }
        }
    }

}

double HungarianAssignment::best_cost() const {
    const i_vector& res =  m_bpm.c2r_matches();
    double cost = 0;
    for (int c=0; c < m_cost.columns(); ++c) {
        int r = res[c];
        cost = cost + m_orig_cost(r, c);
    }
    return cost;
}

}