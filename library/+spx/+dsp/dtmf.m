function [signal, fs] = dtmf(symbols, options)

% The symbols on telephone pad are
% {'1','2','3','4','5','6','7','8','9','*','0','#'}

if nargin < 2
    options = struct;
end
if ~isfield(options, 'duration')
    % default duration of each tone in ms
    options.duration = 100;
end
if ~isfield(options, 'fs')
    % default sampling frequency
    options.fs = 8000;
end
if ~isfield(options, 'noise_gap')
    % gap between tones for noise in ms
    options.noise_gap = 100;
end
% there are 4 low frequencies
low_frequencies = [697 770 852 941];
% there are 4 high frequencies
high_frequencies = [1209 1336 1477];


% prepare an array of 12 elements for low frequencies of each tone
lows = repelem(low_frequencies, 3);
% prepare an array of 12 elements for high frequencies of each tone
highs = repmat(high_frequencies, 1, 4);

% pair them up
f_pairs = [lows; highs];


% sampling frequency
fs = options.fs;
% duration of tone in milliseconds
duration = options.duration;
% number of samples for each tone
N = fs * duration / 1000;
% time stamp for each sample in this duration:
t   = (0:N-1)/fs;
pit = 2*pi*t;

% number of symbols
n_sym = numel(symbols);
% space for storing tones for each symbol
% each column represent the tone for one symbol
tones = zeros(N, n_sym);
for i=1:numel(symbols),
    switch (symbols{i})
        case '1'
            tones(:,i) = sum(sin(f_pairs(:,1)*pit))';
        case '2'
            tones(:,i) = sum(sin(f_pairs(:,2)*pit))';
        case '3'
            tones(:,i) = sum(sin(f_pairs(:,3)*pit))';
        case '4'
            tones(:,i) = sum(sin(f_pairs(:,4)*pit))';
        case '5'
            tones(:,i) = sum(sin(f_pairs(:,5)*pit))';
        case '6'
            tones(:,i) = sum(sin(f_pairs(:,6)*pit))';
        case '7'
            tones(:,i) = sum(sin(f_pairs(:,7)*pit))';
        case '8'
            tones(:,i) = sum(sin(f_pairs(:,8)*pit))';
        case '9'
            tones(:,i) = sum(sin(f_pairs(:,9)*pit))';
        case '*'
            tones(:,i) = sum(sin(f_pairs(:,10)*pit))';
        case '0'
            tones(:,i) = sum(sin(f_pairs(:,11)*pit))';
        case '#'
            tones(:,i) = sum(sin(f_pairs(:,12)*pit))';
    end
end

% noisy delay in number of samples 
delay = fs * options.noise_gap / 1000;
% noisy delay after each symbol
delay_noise = 0.05 * randn(delay, n_sym);
% concatenate the signal with noise
tones = [tones; delay_noise];
% let's create some noise in the front too
front_noise = 0.05 * randn(delay, 1);
% vectorize all the tones with noise
signal  = [front_noise; tones(:)];
end
