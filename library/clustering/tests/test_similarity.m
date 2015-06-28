function test_suite = test_similarity
  initTestSuite;
end


function test_k_nearest
    m = [1.0000    0.6000    0.2000
    0.6000    1.0000    0.3000
    0.2000    0.3000    1.0000];
    m = SPX_Similarity.filter_k_nearest_neighbors(m, 2);
    assertEqual(m, [ 1.0000    0.6000         0
    0.6000    1.0000    0.3000
         0    0.3000    1.0000]);
    % We consider a graph with [[2,3,4], [1], [1, 4], [1, 3]]
    m = [
    0 1 1 1
    1 0 0 0
    1 0 0 1
    1 0 1 0];
    m2 = SPX_Similarity.filter_k_nearest_neighbors(m, 2);
    assertEqual(m2, m);
    m2 = SPX_Similarity.filter_k_nearest_neighbors(m, 1);
    assertEqual(m2, [0 1 1 1 
        1 0 0 0 
        1 0 0 0
        1 0 0 0]);
end


function test_sim_1
    x = [1 2 3];
end

