classdef spx.pursuit.PhaseTransitionAnalysisOld < handle
 % This class defines a framework for phase transition analysis
 % of a sparse recovery solver

properties
    % Number of atoms
    N
    % The value of Ks for which simulation will be done
    Ks
    % The value of Ms for which simulation will be done
    Ms
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
    % Minimum M required for a given value of K
    MinimumMs 
end

methods
    function self = spx.pursuit.PhaseTransitionAnalysisOld(N_)
        self.N = N_;
        max_k  = round(self.N / 16);
        self.Ks = 1:max_k;
        max_n = round(self.N / 2);
        self.Ms = [1 2:2:max_n];
    end

    function result = run(self, dict_model, data_model, recovery_solver)
        ks = self.Ks;
        ms = self.Ms;
        num_ks = numel(ks);
        num_ms = numel(ms);
        N = self.N;
        num_trials = self.NumTrials;
        % Memory allocations
        self.SuccessRates = zeros(num_ks, num_ms);
        self.TotalSimulationTimes = zeros(num_ks, num_ms);
        self.AverageSimulationTimes = zeros(num_ks, num_ms);
        for nk = 1:num_ks
            K = ks(nk);
            for nm = 1:num_ms
                M = ms(nm);
                fprintf('\n\nSimulating for K = %d, M = %d\n', K, M);
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

        self.MinimumMs  = zeros(num_ks, 1);
        for nk=1:num_ks
            row = self.SuccessRates(nk, :);
            min_m_index = find(row >=1, 1);
            if isempty(min_m_index)
                self.MinimumMs(nk) = N;
            else
                self.MinimumMs(nk) = ms(min_m_index);
            end
        end

        result = self
    end

    function save_results(self, target_file_path)
        fprintf('Saving data.\n');
        SuccessRates  = self.SuccessRates;
        TotalSimulationTimes = self.TotalSimulationTimes;
        AverageSimulationTimes = self.AverageSimulationTimes;
        MinimumMs = self.MinimumMs;
        Ks = self.Ks;
        Ms = self.Ms;
        N = self.N;
        NumTrials = self.NumTrials;
        save(target_file_path, 'N', 'Ks', 'Ms', 'NumTrials', ...
            'SuccessRates', 'TotalSimulationTimes', ...
            'AverageSimulationTimes', 'MinimumMs');
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
        imagesc(data.Ms, data.Ks, data.SuccessRates);
        set(gca,'YDir','normal');
        colormap gray;
        ylabel('K (sparsity level)');
        xlabel('M (measurements)');

        title(sprintf('Phase Transition Diagram for %s: N=%d', graph_title, data.N));
        colorbar;

        if isfield(options, 'export') && options.export
            file_path = sprintf('%s/%s_%s_phase_transition.png', options.export_dir, solver_name, options.export_name);
            export_fig(file_path, '-r120', '-nocrop');
            file_path = sprintf('%s/%s_%s_phase_transition.pdf', options.export_dir, solver_name, options.export_name);
            export_fig(file_path);
        end

        mf.new_figure('K vs Minimum M');
        plot(data.Ks, data.MinimumMs, '-s');
        grid on;
        xlabel('Sparsity level: K');
        ylabel('Minimum number of measurements');
        title('Minimum measurements required for different sparsity levels');

        if isfield(options, 'export') && options.export
            file_path = sprintf('%s/%s_%s_k_vs_min_m.png', options.export_dir, solver_name, options.export_name);
            export_fig(file_path, '-r120', '-nocrop');
            file_path = sprintf('%s/%s_%s_k_vs_min_m.pdf', options.export_dir, solver_name, options.export_name);
            export_fig(file_path);
        end

        if isfield(options, 'chosen_ks')
            mf.new_figure('Recovery rate vs  Number of Measurements');
            hold all;
            chosen_ks = intersect(options.chosen_ks,  data.Ks);
            chosen_ks = sort(chosen_ks);
            legends = cell(1, numel(chosen_ks));
            plot_styles = SPX.plot_styles;
            num_plot_styles = numel(plot_styles);
            for k=1:numel(chosen_ks)
                K = chosen_ks(k);
                nk = find(data.Ks == K);
                success_rates = data.SuccessRates(nk, :);
                plot_style = plot_styles{mod(k,num_plot_styles)+1};
                plot(data.Ms, success_rates, plot_style);
                legends{k} = sprintf('K=%d', K);
            end
            legend(legends, 'Location', 'southeast');
            xlabel('Number of measurements');
            ylabel('Recovery probability');
            grid on;
            if isfield(options, 'export') && options.export
                file_path = sprintf('%s/%s_%s_recovery_vs_m_over_ks.png', options.export_dir, solver_name, options.export_name);
                export_fig(file_path, '-r120', '-nocrop');
                file_path = sprintf('%s/%s_%s_recovery_vs_m_over_ks.pdf', options.export_dir, solver_name, options.export_name);
                export_fig(file_path);
            end
        end

    end
end

end

