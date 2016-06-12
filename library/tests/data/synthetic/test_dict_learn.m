function tests = test_dict_learn
  tests = functiontests(localfunctions);
end

function setupOnce(testCase)
    figure;
end
function teardownOnce(testCase)
    close;
end


function test1(testCase)
    import spx.data.synthetic.dict_learn_problems;
    problem = dict_learn_problems.problem_random_dict();
    imagesc(problem.true_dictionary);
    pause(.1);
end

