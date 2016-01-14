classdef SPX_PhaseTransitionConfiguration < handle

properties
    % Number of atoms
    N
    % Different values of Ms for which simulation will be done
    Ms
    % The value of Ks and Ms for which simulation will be done
    Configuration
    % Number of M values for different undersampling rates
    NumMValues
    % Number of K values for a given undersampling rate
    NumKValues
    Etas
    Rhos
end

methods
    function self = SPX_PhaseTransitionConfiguration(N_)
    	if ~SPX_Number.is_power_of_2(N_)
    		error(sprintf('N=%d must be a power of 2.', N_));
    	end
    	if mod(N_, 32) ~= 0
    		error(sprintf('N=%d must be a multiple of 32.', N_));
    	end
        self.N = N_;
    	% Minimum number of measurements
        if N_ <= 256
	    	M_min  = 16;
	    else
	    	M_min  = 32;
	    end
    	% Minimum undersampling rate
    	eta_min = M_min / self.N;
    	% Number of possible values of K for each value of M
    	num_k_values = M_min;
    	% K/Ms 
    	rhos = (1:num_k_values) / M_min;
    	num_m_values = self.N / M_min;
    	Ms = (1:num_m_values )  * M_min;
    	etas = Ms / self.N;
    	self.Configuration = zeros(num_m_values, num_k_values, 4);
		for m=1:num_m_values
			eta  = etas(m);
			M = Ms(m);
	    	for k=1:num_k_values
	    		rho = rhos(k);
	    		K = rho * M;
	    		self.Configuration(m, k, :) = [M, K, eta, rho];
    		end
    	end
    	self.NumMValues =num_m_values;
    	self.NumKValues = num_k_values;
    	self.Etas = etas;
    	self.Rhos = rhos;
    	self.Ms = Ms;
    end

    function result = num_configurations(self)
    	result = self.NumMValues * self.NumKValues;
    end

    function print_configuration(self)
    	num_m_values = self.NumMValues;
    	num_k_values = self.NumKValues;
		for m=1:num_m_values
	    	for k=1:num_k_values
	    		cfg = self.Configuration(m, k, :);
	    		M = cfg(1);
	    		K = cfg(2);
	    		eta = cfg(3);
	    		rho = cfg(4);
	    		fprintf('eta=%.2f, rho=%.2f, M=%d, K=%d\n', eta, rho, M, K);
	    		if rho ~= K / M
	    			error('Calculation mistake');
	    		end
    		end
    	end
    	fprintf('\nNumber of configurations: %d\n', self.num_configurations);
    	fprintf('\nNumber of undersampling rates (etas)=%d\n', self.NumMValues);
    	fprintf('\nNumber of K values (rhos)=%d\n', self.NumKValues);
    	fprintf('\n Etas: ');
    	fprintf('%.02f ', self.Etas);
    	fprintf('\n');
    	fprintf('\n Rhos: ');
    	fprintf('%.02f ', self.Rhos);
    	fprintf('\n');
    end


    function plot_configuration(self)
    	etas = self.Etas;
    	rhos = self.Rhos;
    	num_m_values = self.NumMValues;
    	num_k_values = self.NumKValues;
    	data = zeros(num_m_values, num_k_values);
		for m=1:num_m_values
	    	for k=1:num_k_values
	    		data(m, k) = etas(m) * rhos(k); 
    		end
    	end
        mf = SPX_Figures();
        mf.new_figure('Phase Transition Configuration');
        imagesc(etas, rhos, data);
        set(gca,'YDir','normal');
        colormap gray;
        ylabel('\rho (Sparsity)');
        xlabel('\eta (Undersampling Rate)');
    end
end

end