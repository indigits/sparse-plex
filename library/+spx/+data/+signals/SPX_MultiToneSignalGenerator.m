% This script generates a signal in which different
% frequencies are present at different points of time.
% Multiple frequencies may be present simultaneously.
classdef SPX_MultiToneSignalGenerator < handle
properties
    % Signal duration
    TotalDuration = 1000
    % Sampling frequency
    SamplingFrequency = 1
    % Frequencies of each tone
    Frequencies = []
    % Origins of each tone
    Origins = []
    % Durations of each tone
    Durations = []
    % Amplitudes of each tone
    Amplitudes = []
end

methods
    function self = SPX_MultiToneSignalGenerator()
    end

    function [x, t] = run(self)
        % Number of samples
        N = fix(self.TotalDuration * self.SamplingFrequency);
        % Time points
        tp = (0:N-1);
        % Signal vector
        x = zeros(1,N);
        fq = self.Frequencies / self.SamplingFrequency;
        origins = fix(self.Origins * self.SamplingFrequency);
        durations = fix(self.Durations * self.SamplingFrequency);
        amplitudes = self.Amplitudes;
        num_tones = length(fq);
        for ii=1:num_tones
            % Lets construct a full signal for this frequency
            % TODO, we need not construct full signal
            xc = amplitudes(ii)*cos(2*pi*fq(ii)*tp);
            % Lets identify the initial time for this frequency
            ti = origins(ii) + 1;
            % Lets identify the finish time for this frequency
            tf = origins(ii) + durations(ii);
            % Lets add this frequency [over the segment initial-final]
            % to the overall signal
            x(ti:tf) = x(ti:tf) + xc(ti:tf);
        end
        if nargout > 1
            % Corresponding time stamps
            t = tp / self.SamplingFrequency;
        end
    end
end
end

