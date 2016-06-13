classdef PhaseTransitionAnalysis < handle
 % This class defines a framework for phase transition analysis
 % of a sparse recovery solver

properties
    % Phase Transition Analysis Configuration
    Configuration
    % Number of trials for each setup
    NumTrials = 500
    % SNR level (empty means noiseless)
    SNR = []
end

properties(SetAccess=private)
    % Success rate for each configuration
    SuccessRates
    % Total Simulation time for each configuration
    TotalSimulationTimes
    % Average simulation time for each configuration
    AverageSimulationTimes
end

methods
    function self = PhaseTransitionAnalysis(N_)
        self.Configuration = spx.commons.PhaseTransitionConfiguration(N_);
    end

    function result = run(self, dict_model, data_model, recovery_solver)
        cfg = self.Configuration;
        num_etas = cfg.NumEtas;
        num_rhos = cfg.NumRhos;
        N = cfg.N;
        num_trials = self.NumTrials;
        % Memory allocations
        % K is Y-axis (rows), M is X-axis (columns)
        self.SuccessRates = zeros(num_rhos, num_etas);
        self.TotalSimulationTimes = zeros(num_rhos, num_etas);
        self.AverageSimulationTimes = zeros(num_rhos, num_etas);
        for nm=1:num_etas
            for nk=1:num_rhos
                current_cfg = cfg.Configuration(nk, nm, :);
                K = current_cfg(1);
                M = current_cfg(2);
                eta = current_cfg(3);
                rho = current_cfg(4);
                fprintf('\n\nSimulating for eta=%.2f, rho=%.2f, K=%d, M=%d\n', eta, rho, K, M);
                if nk > 1
                    % It is possible that previous K was same as this one.
                    pre_nk = nk - 1;
                    prev_cfg = cfg.Configuration(pre_nk, nm, :);
                    prev_K = prev_cfg(1);
                    if prev_K == K
                        fprintf('Copying data from previous simulation\n');
                        self.SuccessRates(nk, nm) = self.SuccessRates(pre_nk, nm);
                        self.TotalSimulationTimes(nk, nm) = self.TotalSimulationTimes(pre_nk, nm);
                        self.AverageSimulationTimes(nk, nm) = self.AverageSimulationTimes(pre_nk, nm);
                        continue;
                    end
                end
                % Construct a sensing matrix.
                Phi = dict_model(M, N);
                num_successes = 0;
                num_failures = 0;
                t_start = tic;
                for e = 1:num_trials
                    % Construct a sparse vector
                    x = data_model(N, K);
                    % Construct measurement vector
                    y0  = Phi * x;
                    if isempty(self.SNR)
                        y = y0;
                    else
                        % we need to corrupt the signal with noise
                        noises = spx.data.noise.Basic.createNoise(y0, self.SNR);
                        y = y0 + noises;
                    end
                    % Solve the recovery problem
                    x_rec = recovery_solver(Phi, K, y);
                    % Compare references and reconstructions 
                    sscomp = spx.commons.SparseSignalsComparison(x, x_rec, K);
                    all_success = sscomp.all_have_matching_supports();
                    % stats = spx.commons.sparse.recovery_performance(Phi, K, y, x, x_rec);
                    % Check whether we succeeded or failed.
                    if all_success
                        num_successes = num_successes + 1;
                        fprintf('S');
                    else
                        num_failures = num_failures + 1;
                        fprintf('F');
                    end
                    if mod(e, 50) == 0
                        fprintf('\n');
                    end
                end
                % Total time spent for this combination.
                total_time = toc(t_start);
                average_time = total_time / num_trials;
                success_rate = num_successes / num_trials;
                self.SuccessRates(nk, nm) = success_rate;
                self.TotalSimulationTimes(nk, nm) = total_time;
                self.AverageSimulationTimes(nk, nm) = average_time;
                % We should save data for a particular value of K
            end
            % We start from first M value for next K iteration.
            mStart = 1;
        end

        result = self
    end

    function save_results(self, target_file_path)
        fprintf('Saving data.\n');
        SuccessRates  = self.SuccessRates;
        TotalSimulationTimes = self.TotalSimulationTimes;
        AverageSimulationTimes = self.AverageSimulationTimes;
        cfg = self.Configuration;
        NumEtas = cfg.NumEtas;
        NumRhos = cfg.NumRhos;
        Etas = cfg.Etas;
        Rhos = cfg.Rhos;
        N = cfg.N;
        Ms = cfg.Ms;
        NumTrials = self.NumTrials;
        Configuration = cfg.Configuration;
        save(target_file_path, 'N', 'NumEtas', 'NumRhos', 'NumTrials', ...
            'Configuration', 'Etas', 'Rhos', 'Ms', ...
            'SuccessRates', 'TotalSimulationTimes', ...
            'AverageSimulationTimes');
    end    
end

methods(Static)
    function print_results(result_file_path, solver_name, options)
        % Prints and exports results of phase transition analysis
        data = load(result_file_path);
        mf = spx.graphics.Figures();
        graph_title  = solver_name;
        if isfield(options, 'subtitle')
            graph_title = sprintf('%s (%s)', graph_title, options.subtitle);
        end
        mf.new_figure(sprintf('%s: Phase Transition Diagram', graph_title));
        imagesc(data.Etas, data.Rhos, data.SuccessRates);
        set(gca,'YDir','normal');
        colormap gray;
        ylabel('Oversampling rate (\rho=K/M)');
        xlabel('Undersampling Rate (\eta=M/N)');

        title(sprintf('Phase Transition Diagram for %s: N=%d', graph_title, data.N));
        colorbar;

        if isfield(options, 'export') && options.export
            file_path = sprintf('%s/%s_%s_phase_transition.png', options.export_dir, solver_name, options.export_name);
            export_fig(file_path, '-r120', '-nocrop');
            file_path = sprintf('%s/%s_%s_phase_transition.pdf', options.export_dir, solver_name, options.export_name);
            export_fig(file_path);
        end
    end
end

end

