classdef dict_learn_problems

methods(Static)

    function problem = problem_random_dict()
        % Constructs a simple dictionary learning problem

        % Sparsity level in each signal
        problem.K = 4;
        % Number of atoms in dictionary
        problem.D = 64;
        % Signal dimension
        problem.N = 32;
        % Number of signals to use for learning
        problem.S = 4000;
        % Noise level
        problem.sigma = 0.0;
        % Let us create a random dictionary
        problem.true_dictionary = randn(problem.N, problem.D);
        % Let us normalize its columns
        problem.true_dictionary = spx.norm.normalize_l2(problem.true_dictionary);
        Alpha = zeros(problem.D, problem.S);
        for i=1:problem.S
            sg = spx.data.synthetic.SparseSignalGenerator(problem.D, problem.K, 1);
            % Representations of sample signals
            Alpha(:, i) = sg.biUniform();
        end
        problem.representations = Alpha;
        % Sample signals generated from dictionary
        problem.signals0  = problem.true_dictionary * Alpha;
        % Added noise Gaussian
        ng = spx.data.noise.Basic(problem.N, problem.S);
        problem.noises = ng.gaussian(problem.sigma);
        problem.signals = problem.signals0 + problem.noises;
        problem.snrs = spx.snr.SNR(problem.signals0, problem.noises);
    end


end

end
