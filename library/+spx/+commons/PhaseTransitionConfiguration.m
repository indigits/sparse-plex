classdef PhaseTransitionConfiguration < handle

properties
    % Number of atoms
    N
    % Different values of Ms for which simulation will be done
    Ms
    % The value of Ks and Ms for which simulation will be done
    Configuration
    % Number of M values for different undersampling rates
    NumEtas
    % Number of Sparsity levels for a given undersampling rate
    NumRhos
    Etas
    Rhos
end

methods
    function self = PhaseTransitionConfiguration(N_)
    	if ~spx.discrete.number.is_power_of_2(N_)
    		error(sprintf('N=%d must be a power of 2.', N_));
    	end
    	if mod(N_, 32) ~= 0
    		error(sprintf('N=%d must be a multiple of 32.', N_));
    	end
        self.N = N_;
    	% Minimum number of measurements
    	M_min = 4;
     	% if N_ <= 256
	    % 	M_min  = 16;
	    % else
	    % 	M_min  = 32;
	    % end
    	% Minimum undersampling rate
    	eta_min = M_min / self.N;
    	% Number of possible values of K for each value of M
    	num_rhos = 64;
    	% K/Ms 
    	rhos = (1:num_rhos) / num_rhos;
    	num_etas = self.N / M_min;
    	Ms = (1:num_etas )  * M_min;
    	etas = Ms / self.N;
    	self.Configuration = zeros(num_rhos, num_etas, 4);
		for m=1:num_etas
			eta  = etas(m);
			M = Ms(m);
	    	for k=1:num_rhos
	    		rho = rhos(k);
	    		K = ceil(rho * M);
	    		self.Configuration(k, m, :) = [K, M, eta, rho];
    		end
    	end
    	self.NumEtas =num_etas;
    	self.NumRhos = num_rhos;
    	self.Etas = etas;
    	self.Rhos = rhos;
    	self.Ms = Ms;
    end

    function result = num_configurations(self)
    	result = self.NumEtas * self.NumRhos;
    end

    function print_configuration(self)
    	num_etas = self.NumEtas;
    	num_rhos = self.NumRhos;
		for m=1:num_etas
	    	for k=1:num_rhos
	    		cfg = self.Configuration(k, m, :);
	    		K = cfg(1);
	    		M = cfg(2);
	    		eta = cfg(3);
	    		rho = cfg(4);
	    		fprintf('eta=%.2f, rho=%.2f, K=%d, M=%d\n', eta, rho, K, M);
	    		if K ~= ceil (rho * M)
	    			error('Calculation mistake');
	    		end
    		end
    	end
    	fprintf('\nNumber of configurations: %d\n', self.num_configurations);
    	fprintf('\nNumber of undersampling rates (etas)=%d\n', self.NumEtas);
    	fprintf('\nNumber of K values (rhos)=%d\n', self.NumRhos);
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
    	num_etas = self.NumEtas;
    	num_rhos = self.NumRhos;
    	data = zeros(num_rhos, num_etas);
		for m=1:num_etas
	    	for k=1:num_rhos
	    		data(k, m) = rhos(k) * etas(m); 
    		end
    	end
        mf = spx.graphics.Figures();
        mf.new_figure('Phase Transition Configuration');
        imagesc(etas, rhos, data);
        set(gca,'YDir','normal');
        colormap gray;
        ylabel('\rho (Sparsity)');
        xlabel('\eta (Undersampling Rate)');
    end
end

end