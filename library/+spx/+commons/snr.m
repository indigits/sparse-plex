classdef snr
    %SNR helper functions for calculating SNR
    
    properties
    end

    methods(Static)
        function result = SNR(signal, noise)
            sigEnergy = sum(signal .* conj(signal));
            noiseEnergy = sum(noise .* conj(noise));
            result=10*log10(sigEnergy./noiseEnergy);
        end
        function result = recSNRdB(signal, reconstruction)
            result=20*log10(norm(signal)/norm(signal-reconstruction));
        end
        
        function result = energyDB(signal)
            result = 20*log10(norm(signal));
        end
        function result = recSNR(signal, reconstruction)
            noise = (signal - reconstruction);
            result = (signal' * signal) / (noise'*noise);
        end
        function result = normalizedErrorEnergy(signal, reconstruction)
            noise = (signal - reconstruction);
            result = (noise' * noise) / (signal'*signal);
        end
        
        function result = recSNRsdB(signals, reconstructions)
            ratios = SPX_SNR.recSNRs(signals, reconstructions);
            result= 10 * log10(ratios);
        end
        
        function result = recSNRs(signals, reconstructions)
            sigEngergies =  SPX_SNR.energies(signals);
            noiseEnergies =  SPX_SNR.energies(signals - reconstructions);
            result = sigEngergies ./ noiseEnergies;
        end
        
        function result = energies(signals)
            signals = abs(signals);
            signals = signals .^2;
            result = sum(signals, 1);
        end
        
        function result = energiesDB(signals)
            energies = SPX_SNR.energies(signals);
            result = 10* log10(energies);
        end
    end
    
end

